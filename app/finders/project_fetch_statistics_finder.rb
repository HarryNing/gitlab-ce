# frozen_string_literal: true

class ProjectFetchStatisticsFinder
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def execute
    ProjectFetchStatistic.of_project(project)
      .of_last_30_days
      .sorted_by_date_desc
  end
end
