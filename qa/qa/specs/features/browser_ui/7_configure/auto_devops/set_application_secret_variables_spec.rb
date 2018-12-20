# frozen_string_literal: true

require 'pathname'

module QA
  context 'Configure', :orchestrated, :kubernetes do
    describe 'Auto DevOps application secret variables' do
      after do
        @cluster&.remove!
      end

      it 'user sets application secret variable and Auto DevOps passes it to container' do
        Runtime::Browser.visit(:gitlab, Page::Main::Login)
        Page::Main::Login.act { sign_in_using_credentials }

        project = Resource::Project.fabricate! do |p|
          p.name = Runtime::Env.auto_devops_project_name || 'project-with-autodevops'
          p.description = 'Project with Auto Devops'
        end

        # Set an application secret CI variable (prefixed with K8S_SECRET_)
        Resource::CiVariable.fabricate! do |resource|
          resource.project = project
          resource.key = 'K8S_SECRET_OPTIONAL_MESSAGE'
          resource.value = 'You can see this application secret'
        end

        # Disable code_quality check in Auto DevOps pipeline as it takes
        # too long and times out the test
        Resource::CiVariable.fabricate! do |resource|
          resource.project = project
          resource.key = 'CODE_QUALITY_DISABLED'
          resource.value = '1'
        end

        # Create Auto DevOps compatible repo
        Resource::Repository::ProjectPush.fabricate! do |push|
          push.project = project
          push.directory = Pathname
            .new(__dir__)
            .join('../../../../../fixtures/auto_devops_rack')
          push.commit_message = 'Create Auto DevOps compatible rack application'
        end

        Page::Project::Show.act { wait_for_push }

        # Create and connect K8s cluster
        @cluster = Service::KubernetesCluster.new(rbac: true).create!
        kubernetes_cluster = Resource::KubernetesCluster.fabricate! do |cluster|
          cluster.project = project
          cluster.cluster = @cluster
          cluster.install_helm_tiller = true
          cluster.install_ingress = true
          cluster.install_runner = true
        end
        kubernetes_cluster.populate(:ingress_ip)

        project.visit!
        Page::Project::Menu.act { click_ci_cd_settings }
        Page::Project::Settings::CICD.perform do |p|
          p.enable_auto_devops_with_domain(
            "#{kubernetes_cluster.ingress_ip}.nip.io")
        end

        project.visit!
        Page::Project::Menu.act { click_ci_cd_pipelines }
        Page::Project::Pipeline::Index.act { go_to_latest_pipeline }

        Page::Project::Pipeline::Show.perform do |pipeline|
          expect(pipeline).to have_build('build', status: :success, wait: 600)
          expect(pipeline).to have_build('test', status: :success, wait: 600)
          expect(pipeline).to have_build('production', status: :success, wait: 1200)
        end

        Page::Project::Menu.act { click_operations_environments }

        Page::Project::Operations::Environments::Index.perform do |index|
          index.go_to_environment('production')
        end

        Page::Project::Operations::Environments::Show.perform do |show|
          show.view_deployment do
            expect(page).to have_content('Hello World!')
            expect(page).to have_content('You can see this application secret')
          end
        end
      end
    end
  end
end
