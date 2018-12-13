# frozen_string_literal: true

class ProjectFetchStatistic < ActiveRecord::Base
  belongs_to :project

  scope :of_project, ->(project) { where(project: project) }
  scope :of_last_30_days, -> { where('date >= ?', 29.days.ago.to_date) }
  scope :sorted_by_date_desc, -> { order(date: :desc) }
end
