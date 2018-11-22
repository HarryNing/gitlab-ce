module QA
  module Page
    module Project
      module Operations
        module Kubernetes
          class Add < Page::Base
            include QA::Page::Clusters::Shared::Add
          end
        end
      end
    end
  end
end
