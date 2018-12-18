# frozen_string_literal: true

module API
  class ProjectClusters < Grape::API
    include PaginationParams

    before { authenticate! }

    params do
      requires :id, type: String, desc: 'The ID of the project'
    end
    resource :projects, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      desc 'Get all clusters from the project' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Cluster
      end
      params do
        use :pagination
      end
      get ':id/clusters' do
        authorize! :read_cluster, user_project

        present paginate(clusters_for_current_user), with: Entities::Cluster
      end

      desc 'Gets a specific cluster for the project' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Cluster
      end
      params do
        requires :cluster_id, type: Integer, desc: 'The cluster ID'
      end
      get ':id/clusters/:cluster_id' do
        authorize! :read_cluster, user_project

        present cluster, with: Entities::Cluster
      end

      desc 'Adds an existing cluster' do
        detail 'This feature was introduced in GitLab 11.7.'
        success Entities::Cluster
      end
      params do
        requires :name, type: String, desc: 'Cluster name'
        requires :api_url, type: String, desc: 'URL to access the Kubernetes API'
        requires :token, type: String, desc: 'Token to authenticate against Kubernetes'
        optional :namespace, type: String, desc: 'Unique namespace related to Project'
        optional :authorization_type, type: String, desc: 'Authorization type, defaults to RBAC'
      end
      post ':id/add_cluster' do
        authorize! :create_cluster, user_project

        platform_kubernetes_params = declared_params.except(:name)
        platform_kubernetes_params[:authorization_type] ||= :rbac

        cluster_params = {
          name: declared_params[:name],
          enabled: true,
          environment_scope: '*',
          provider_type: :user,
          platform_type: :kubernetes,
          cluster_type: :project,
          clusterable: user_project,
          platform_kubernetes_attributes: platform_kubernetes_params
        }

        new_cluster = ::Clusters::CreateService
          .new(current_user, cluster_params)
          .execute(access_token: token_in_session)
          .present(current_user: current_user)

        if new_cluster.persisted?
          present new_cluster, with: Entities::Cluster
        else
          render_validation_error!(new_cluster)
        end
      end

      desc 'Creates a new cluster' do
      end

      desc 'Update an existing cluster' do
      end

      desc 'Remove a cluster' do
      end
    end

    helpers do
      def clusters_for_current_user
        ClustersFinder.new(user_project, current_user, :all).execute
      end

      def cluster
        @cluster ||= clusters_for_current_user.find(params[:cluster_id])
      end

      def token_in_session
        session[GoogleApi::CloudPlatform::Client.session_key_for_token]
      end
    end
  end
end
