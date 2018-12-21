# frozen_string_literal: true

module Gitlab
  module Checks
    class BaseChecker
      include Gitlab::Utils::StrongMemoize

      attr_reader :change_access
      delegate(*ChangeAccess::ATTRIBUTES, to: :change_access)

      def initialize(change_access)
        @change_access = change_access
      end

      def validate!
        raise NotImplementedError
      end

      private

      def deletion?
        Gitlab::Git.blank_ref?(newrev)
      end

      def update?
        !Gitlab::Git.blank_ref?(oldrev) && !deletion?
      end

      def updated_from_web?
        protocol == 'web'
      end

      def tag_exists?
        project.repository.tag_exists?(tag_name)
      end

      def with_cached_validations(resource, resource_id)
        Gitlab::SafeRequestStore.fetch(cache_key_for_resource(resource, resource_id)) do
          yield(resource)
        end
      end

      def cache_key_for_resource(resource, resource_id)
        "git_access:#{klass_name_for_cache_key(self)}:#{klass_name_for_cache_key(resource)}:#{resource_id}"
      end

      def klass_name_for_cache_key(resource)
        resource.class.name.demodulize.underscore
      end
    end
  end
end
