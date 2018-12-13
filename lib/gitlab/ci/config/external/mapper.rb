# frozen_string_literal: true

module Gitlab
  module Ci
    class Config
      module External
        class Mapper
          FILE_CLASSES = [
            External::File::Remote,
            External::File::Template,
            External::File::Local
          ].freeze

          def initialize(values, project, sha)
            @locations = Array(values.fetch(:include, []))
            @project = project
            @sha = sha
          end

          def process
            locations.map { |location| build_external_file(location) }
          end

          private

          attr_reader :locations, :project, :sha

          def build_external_file(location)
            options = { project: project, sha: sha }

            FILE_CLASSES.each do |file_class|
              file = file_class.new(location, options)
              return file if file.matching?
            end

            External::File::NotSupported.new(
              location, options)
          end
        end
      end
    end
  end
end
