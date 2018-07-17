## Contribute to GitLab

For a first-time step-by-step guide to the contribution process, see
["Contributing to GitLab"](https://about.gitlab.com/contributing/).

Thank you for your interest in contributing to GitLab. This guide details how
to contribute to GitLab in a way that is efficient for everyone.

Looking for something to work on? Look for issues with the label [Accepting Merge Requests](#i-want-to-contribute).

GitLab comes into two flavors, GitLab Community Edition (CE) our free and open
source edition, and GitLab Enterprise Edition (EE) which is our commercial
edition. Throughout this guide you will see references to CE and EE for
abbreviation.

If you have read this guide and want to know how the GitLab [core team]
operates please see [the GitLab contributing process](PROCESS.md).

- [GitLab Inc engineers should refer to the engineering workflow document](https://about.gitlab.com/handbook/engineering/workflow/)

## Security vulnerability disclosure

Please report suspected security vulnerabilities in private to
`support@gitlab.com`, also see the
[disclosure section on the GitLab.com website](https://about.gitlab.com/disclosure/).
Please do **NOT** create publicly viewable issues for suspected security
vulnerabilities.

## Code of conduct

As contributors and maintainers of this project, we pledge to respect all
people who contribute through reporting issues, posting feature requests,
updating documentation, submitting pull requests or patches, and other
activities.

We are committed to making participation in this project a harassment-free
experience for everyone, regardless of level of experience, gender, gender
identity and expression, sexual orientation, disability, personal appearance,
body size, race, ethnicity, age, or religion.

Examples of unacceptable behavior by participants include the use of sexual
language or imagery, derogatory comments or personal attacks, trolling, public
or private harassment, insults, or other unprofessional conduct.

Project maintainers have the right and responsibility to remove, edit, or
reject comments, commits, code, wiki edits, issues, and other contributions
that are not aligned to this Code of Conduct. Project maintainers who do not
follow the Code of Conduct may be removed from the project team.

This code of conduct applies both within project spaces and in public spaces
when an individual is representing the project or its community.

Instances of abusive, harassing, or otherwise unacceptable behavior can be
reported by emailing `contact@gitlab.com`.

This Code of Conduct is adapted from the [Contributor Covenant][contributor-covenant], version 1.1.0,
available at [http://contributor-covenant.org/version/1/1/0/](http://contributor-covenant.org/version/1/1/0/).

## Closing policy for issues and merge requests

GitLab is a popular open source project and the capacity to deal with issues
and merge requests is limited. Out of respect for our volunteers, issues and
merge requests not in line with the guidelines listed in this document may be
closed without notice.

Please treat our volunteers with courtesy and respect, it will go a long way
towards getting your issue resolved.

Issues and merge requests should be in English and contain appropriate language
for audiences of all ages.

If a contributor is no longer actively working on a submitted merge request
we can decide that the merge request will be finished by one of our
[Merge request coaches][team] or close the merge request. We make this decision
based on how important the change is for our product vision. If a Merge request
coach is going to finish the merge request we assign the
~"coach will finish" label.

## Helping others

Please help other GitLab users when you can.
The methods people will use to seek help can be found on the [getting help page][getting-help].

Sign up for the mailing list, answer GitLab questions on StackOverflow or
respond in the IRC channel. You can also sign up on [CodeTriage][codetriage] to help with
the remaining issues on the GitHub issue tracker.

## I want to contribute!

If you want to contribute to GitLab [issues with the label `Accepting Merge Requests` and small weight][accepting-mrs-weight]
is a great place to start. Issues with a lower weight (1 or 2) are deemed
suitable for beginners. These issues will be of reasonable size and challenge,
for anyone to start contributing to GitLab. If you have any questions or need help visit [Getting Help](https://about.gitlab.com/getting-help/#discussion) to
learn how to communicate with GitLab. If you're looking for a Gitter or Slack channel
please consider we favor
[asynchronous communication](https://about.gitlab.com/handbook/communication/#internal-communication) over real time communication. Thanks for your contribution!

## Contribution Flow

When contributing to GitLab, your merge request is subject to review by merge request maintainers of a particular specialty.

When you submit code to GitLab, we really want it to get merged, but there will be times when it will not be merged.

When maintainers are reading through a merge request they may request guidance from other maintainers. If merge request maintainers conclude that the code should not be merged, our reasons will be fully disclosed. If it has been decided that the code quality is not up to GitLab’s standards, the merge request maintainer will refer the author to our docs and code style guides, and provide some guidance.

Sometimes style guides will be followed but the code will lack structural integrity, or the maintainer will have reservations about the code’s overall quality. When there is a reservation the maintainer will inform the author and provide some guidance.  The author may then choose to update the merge request. Once the merge request has been updated and reassigned to the maintainer, they will review the code again. Once the code has been resubmitted any number of times, the maintainer may choose to close the merge request with a summary of why it will not be merged, as well as some guidance. If the merge request is closed the maintainer will be open to discussion as to how to improve the code so it can be approved in the future.

GitLab will do its best to review community contributions as quickly as possible. Specially appointed developers review community contributions daily. You may take a look at the [team page](https://about.gitlab.com/team/) for the merge request coach who specializes in the type of code you have written and mention them in the merge request.  For example, if you have written some JavaScript in your code then you should mention the frontend merge request coach. If your code has multiple disciplines you may mention multiple merge request coaches.

GitLab receives a lot of community contributions, so if your code has not been reviewed within 4 days of its initial submission feel free to re-mention the appropriate merge request coach.

When submitting code to GitLab, you may feel that your contribution requires the aid of an external library. If your code includes an external library please provide a link to the library, as well as reasons for including it.

When your code contains more than 500 changes, any major breaking changes, or an external library, `@mention` a maintainer in the merge request. If you are not sure who to mention, the reviewer will add one early in the merge request process.

[core team]: https://about.gitlab.com/core-team/
[team]: https://about.gitlab.com/team/
[getting-help]: https://about.gitlab.com/getting-help/
[codetriage]: http://www.codetriage.com/gitlabhq/gitlabhq
[accepting-mrs-weight]: https://gitlab.com/gitlab-org/gitlab-ce/issues?assignee_id=0&label_name[]=Accepting%20Merge%20Requests&sort=weight_asc
[ce-tracker]: https://gitlab.com/gitlab-org/gitlab-ce/issues
[ee-tracker]: https://gitlab.com/gitlab-org/gitlab-ee/issues
[google-group]: https://groups.google.com/forum/#!forum/gitlabhq
[stackoverflow]: https://stackoverflow.com/questions/tagged/gitlab
[fpl]: https://gitlab.com/gitlab-org/gitlab-ce/issues?label_name=feature+proposal
[accepting-mrs-ce]: https://gitlab.com/gitlab-org/gitlab-ce/issues?label_name=Accepting+Merge+Requests
[accepting-mrs-ee]: https://gitlab.com/gitlab-org/gitlab-ee/issues?label_name=Accepting+Merge+Requests
[gitlab-mr-tracker]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests
[gdk]: https://gitlab.com/gitlab-org/gitlab-development-kit
[git-squash]: https://git-scm.com/book/en/Git-Tools-Rewriting-History#Squashing-Commits
[closed-merge-requests]: https://gitlab.com/gitlab-org/gitlab-ce/merge_requests?assignee_id=&label_name=&milestone_id=&scope=&sort=&state=closed
[definition-of-done]: http://guide.agilealliance.org/guide/definition-of-done.html
[contributor-covenant]: http://contributor-covenant.org
[rss-source]: https://github.com/bbatsov/ruby-style-guide/blob/master/README.md#source-code-layout
[rss-naming]: https://github.com/bbatsov/ruby-style-guide/blob/master/README.md#naming
[changelog]: doc/development/changelog.md "Generate a changelog entry"
[doc-guidelines]: doc/development/documentation/index.md "Documentation guidelines"
[js-styleguide]: doc/development/fe_guide/style_guide_js.md "JavaScript styleguide"
[scss-styleguide]: doc/development/fe_guide/style_guide_scss.md "SCSS styleguide"
[newlines-styleguide]: doc/development/newlines_styleguide.md "Newlines styleguide"
[UX Guide for GitLab]: http://docs.gitlab.com/ce/development/ux_guide/
[license-finder-doc]: doc/development/licensing.md
[GitLab Inc engineering workflow]: https://about.gitlab.com/handbook/engineering/workflow/#labelling-issues
[polling-etag]: https://docs.gitlab.com/ce/development/polling.html
[testing]: doc/development/testing_guide/index.md
[us-english]: https://en.wikipedia.org/wiki/American_English


## Workflow labels
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current workflow labels. 

### Type labels (~"feature proposal", ~bug, ~customer, etc.)
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current type labels. 

### Subject labels (~wiki, ~"container registry", ~ldap, ~api, etc.)
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current subject labels. 

### Team labels (~"CI/CD", ~Discussion, ~Quality, ~Platform, etc.)
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current team labels. 


### Milestone labels (~Deliverable, ~Stretch, ~"Next Patch Release")
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current milestone labels. 


### Bug Priority labels (~P1, ~P2, ~P3, ~P4)
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current bug priority  labels. 


### Bug Severity labels (~S1, ~S2, ~S3, ~S4)
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current severity labels. 

#### Severity impact guidance
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current severity impact guidance. 


### Label for community contributors (~"Accepting Merge Requests")
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current policy regarding community contributor issues. 

## Implement design & UI elements

This [documentation](doc/development/contributing/design.md) outlines the current design and UI guidelines. 

## Issue tracker
This [documentation](doc/development/contributing/issue-worflow.md) outlines the issue tracker process. 

### Issue triaging
This [documentation](doc/development/contributing/issue-worflow.md) outlines the current issue triaging process. 

### Feature proposals
This [documentation](doc/development/contributing/issue-worflow.md) outlines the feature proposal process. 

### Issue tracker guidelines

This [documentation](doc/development/contributing/issue-worflow.md) outlines the issue tracker guidelines. 

### Issue weight

This [documentation](doc/development/contributing/issue-worflow.md) outlines the issue weight guidelines. 

### Regression issues
This [documentation](doc/development/contributing/issue-worflow.md) outlines the regression issue process. 

### Technical and UX debt
This [documentation](doc/development/contributing/issue-worflow.md) about technical and UX debt has been moved. 

### Stewardship
This [documentation](doc/development/contributing/issue-worflow.md) outlines the stewardship process. 

## Merge requests

This [documentation](doc/development/contributing/merge-request-worflow.md) outlines the current merge request process. 

### Merge request guidelines

This [documentation](doc/development/contributing/merge-request-worflow.md) outlines the current merge request guidelines. 

### Contribution acceptance criteria

This [documentation](doc/development/contributing/merge-request-worflow.md) outlines the current acceptance criteria for contributions. 

## Definition of done

This [documentation](doc/development/contributing/merge-request-worflow.md) outlines the defintion of done. 

## Style guides
This [documentation](doc/development/contributing/design.md) outlines the current style guidelines. 

