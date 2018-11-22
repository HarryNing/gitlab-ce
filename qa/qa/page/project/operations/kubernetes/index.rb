module QA
  module Page
    module Project
      module Operations
        module Kubernetes
          class Index < Page::Base
            include QA::Page::Clusters::Shared::Index
          end
        end
      end
    end
  end
end
