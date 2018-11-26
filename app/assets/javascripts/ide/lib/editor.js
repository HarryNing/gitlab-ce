import _ from 'underscore';
import { editor as monacoEditor, languages, KeyCode, KeyMod } from 'monaco-editor';
import { loadWASM } from 'onigasm';
import { Registry } from 'monaco-textmate';
import { wireTmGrammars } from 'monaco-editor-textmate';
import { grammars as textmateGrammars } from 'monaco-textmate-languages/dist/manifest';
import store from '../stores';
import DecorationsController from './decorations/controller';
import DirtyDiffController from './diff/controller';
import Disposable from './common/disposable';
import ModelManager from './common/model_manager';
import editorOptions, { defaultEditorOptions } from './editor_options';
import gitlabTheme from './themes/gl_theme';
import keymap from './keymap.json';

languages.register({ id: 'vue', extensions: ['vue'], mimeTypes: ['text/html'] });

function standardizeColor(color) {
  return color ? color.replace(/^#/, '') : color;
}

function setupMonacoTheme() {
  monacoEditor.defineTheme(gitlabTheme.themeName, {
    ...gitlabTheme.monacoTheme,
    rules: gitlabTheme.monacoTheme.rules.reduce(
      (acc, token) =>
        acc.concat(
          (typeof token.scope === 'string' ? token.scope.split(',') : token.scope).map(s => ({
            token: s.trim(),
            foreground: standardizeColor(token.settings.foreground),
            background: standardizeColor(token.settings.background),
            fontStyle: token.settings.fontStyle,
          })),
        ),
      [],
    ),
  });
  monacoEditor.setTheme(gitlabTheme.themeName);
}

let onigasmLoaded = false;
const loadSyntaxHighlighting = () => {
  // eslint-disable-next-line global-require
  (onigasmLoaded ? Promise.resolve() : loadWASM(require('onigasm/lib/onigasm.wasm')))
    .then(() => {
      onigasmLoaded = true;

      const registry = new Registry({
        getGrammarDefinition: scopeName => {
          const { path } = textmateGrammars.find(g => g.scopeName === scopeName);
          return import(`monaco-textmate-languages/grammars/${path}`).then(content => ({
            format: 'json',
            content: content.default,
          }));
        },
      });

      const grammars = new Map();
      grammars.set('typescript', 'source.tsx');
      grammars.set('javascript', 'source.tsx');
      grammars.set('vue', 'text.html.vue');
      grammars.set('html', 'text.html.basic');
      grammars.set('css', 'source.css');
      grammars.set('json', 'source.json');

      return wireTmGrammars(window.monaco, registry, grammars);
    })
    .catch(e => {
      throw e;
    });
};

export const clearDomElement = el => {
  if (!el || !el.firstChild) return;

  while (el.firstChild) {
    el.removeChild(el.firstChild);
  }
};

export default class Editor {
  static create() {
    if (!this.editorInstance) {
      this.editorInstance = new Editor();
    }
    return this.editorInstance;
  }

  constructor() {
    this.currentModel = null;
    this.instance = null;
    this.dirtyDiffController = null;
    this.disposable = new Disposable();
    this.modelManager = new ModelManager();
    this.decorationsController = new DecorationsController(this);

    languages
      .getLanguages()
      .filter(
        l =>
          l.id === 'javascript' ||
          l.id === 'typescript' ||
          l.id === 'html' ||
          l.id === 'css' ||
          l.id === 'json',
      )
      .forEach(lang => {
        // eslint-disable-next-line no-param-reassign
        lang.loader = () =>
          Promise.resolve({
            language: { tokenizer: { root: [] } },
            conf: {},
          });
      });

    setupMonacoTheme();

    this.debouncedUpdate = _.debounce(() => {
      this.updateDimensions();
    }, 200);
  }

  createInstance(domElement) {
    if (!this.instance) {
      clearDomElement(domElement);

      this.disposable.add(
        (this.instance = monacoEditor.create(domElement, {
          ...defaultEditorOptions,
        })),
        (this.dirtyDiffController = new DirtyDiffController(
          this.modelManager,
          this.decorationsController,
        )),
      );

      this.addCommands();

      window.addEventListener('resize', this.debouncedUpdate, false);
    }
  }

  createDiffInstance(domElement, readOnly = true) {
    if (!this.instance) {
      clearDomElement(domElement);

      this.disposable.add(
        (this.instance = monacoEditor.createDiffEditor(domElement, {
          ...defaultEditorOptions,
          quickSuggestions: false,
          occurrencesHighlight: false,
          renderSideBySide: Editor.renderSideBySide(domElement),
          readOnly,
          renderLineHighlight: readOnly ? 'all' : 'none',
          hideCursorInOverviewRuler: !readOnly,
        })),
      );

      this.addCommands();

      window.addEventListener('resize', this.debouncedUpdate, false);
    }
  }

  createModel(file, head = null) {
    return this.modelManager.addModel(file, head);
  }

  attachModel(model) {
    if (this.isDiffEditorType) {
      this.instance.setModel({
        original: model.getOriginalModel(),
        modified: model.getModel(),
      });

      return;
    }

    this.instance.setModel(model.getModel());
    if (this.dirtyDiffController) this.dirtyDiffController.attachModel(model);

    this.currentModel = model;

    this.instance.updateOptions(
      editorOptions.reduce((acc, obj) => {
        Object.keys(obj).forEach(key => {
          Object.assign(acc, {
            [key]: obj[key](model),
          });
        });
        return acc;
      }, {}),
    );

    if (this.dirtyDiffController) this.dirtyDiffController.reDecorate(model);

    if (typeof WebAssembly === 'object') {
      loadSyntaxHighlighting();
    }
  }

  attachMergeRequestModel(model) {
    this.instance.setModel({
      original: model.getBaseModel(),
      modified: model.getModel(),
    });

    monacoEditor.createDiffNavigator(this.instance, {
      alwaysRevealFirst: true,
    });
  }

  clearEditor() {
    if (this.instance) {
      this.instance.setModel(null);
    }
  }

  dispose() {
    window.removeEventListener('resize', this.debouncedUpdate);

    // catch any potential errors with disposing the error
    // this is mainly for tests caused by elements not existing
    try {
      this.disposable.dispose();

      this.instance = null;
    } catch (e) {
      this.instance = null;

      if (process.env.NODE_ENV !== 'test') {
        // eslint-disable-next-line no-console
        console.error(e);
      }
    }
  }

  updateDimensions() {
    this.instance.layout();
    this.updateDiffView();
  }

  setPosition({ lineNumber, column }) {
    this.instance.revealPositionInCenter({
      lineNumber,
      column,
    });
    this.instance.setPosition({
      lineNumber,
      column,
    });
  }

  onPositionChange(cb) {
    if (!this.instance.onDidChangeCursorPosition) return;

    this.disposable.add(this.instance.onDidChangeCursorPosition(e => cb(this.instance, e)));
  }

  updateDiffView() {
    if (!this.isDiffEditorType) return;

    this.instance.updateOptions({
      renderSideBySide: Editor.renderSideBySide(this.instance.getDomNode()),
    });
  }

  get isDiffEditorType() {
    return this.instance.getEditorType() === 'vs.editor.IDiffEditor';
  }

  static renderSideBySide(domElement) {
    return domElement.offsetWidth >= 700;
  }

  addCommands() {
    const getKeyCode = key => {
      const monacoKeyMod = key.indexOf('KEY_') === 0;

      return monacoKeyMod ? KeyCode[key] : KeyMod[key];
    };

    keymap.forEach(command => {
      const keybindings = command.bindings.map(binding => {
        const keys = binding.split('+');

        // eslint-disable-next-line no-bitwise
        return keys.length > 1 ? getKeyCode(keys[0]) | getKeyCode(keys[1]) : getKeyCode(keys[0]);
      });

      this.instance.addAction({
        id: command.id,
        label: command.label,
        keybindings,
        run() {
          store.dispatch(command.action.name, command.action.params);
          return null;
        },
      });
    });
  }
}
