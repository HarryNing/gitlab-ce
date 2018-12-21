# frozen_string_literal: true

class Projects::ErrorTrackingController < Projects::ApplicationController
  before_action :check_feature_flag!
  before_action :push_feature_flag_to_frontend

  def list
  end

  def index
    external_url, errors = errors_for(@project) 

    render json: {
      external_url: external_url,
      errors: errors
    }
  end

  private

  def errors_for(project)
    settings = settings_for(project)
    return nil, [] unless settings

    ErrorTracking::SentryIssuesService
      .new(settings.uri, settings.token)
      .execute
  end

  def settings_for(project)
    setting = project.error_tracking_setting
    return setting if setting&.enabled?
  end

  def check_feature_flag!
    render_404 unless Feature.enabled?(:error_tracking, project)
  end

  def push_feature_flag_to_frontend
    push_frontend_feature_flag(:error_tracking, current_user)
  end
end
