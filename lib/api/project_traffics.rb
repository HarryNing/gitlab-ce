# frozen_string_literal: true

module API
  class ProjectTraffics < Grape::API
    helpers do
      # rubocop: disable CodeReuse/ActiveRecord
      def total_fetch_stats(fetch_stats)
        fetch_stats.sum(:count)
      end
      # rubocop: enable CodeReuse/ActiveRecord
    end

    before do
      authenticate!
      authorize! :push_code, user_project
    end

    params do
      requires :id, type: String, desc: 'The ID of a project'
    end
    resource :projects, requirements: API::NAMESPACE_OR_PROJECT_REQUIREMENTS do
      desc 'Get the list of project fetch statistics for the last 30 days'
      get ":id/traffic/fetches" do
        fetch_stats = ProjectFetchStatisticsFinder.new(user_project).execute

        present :count, total_fetch_stats(fetch_stats)
        present :fetches, fetch_stats, with: Entities::ProjectFetchStatistic
      end
    end
  end
end
