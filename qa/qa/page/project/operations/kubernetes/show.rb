module QA
  module Page
    module Project
      module Operations
        module Kubernetes
          class Show < Page::Base
            include QA::Page::Clusters::Shared::Show
          end
        end
      end
    end
  end
end
