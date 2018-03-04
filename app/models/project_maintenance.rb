# frozen_string_literal: true

class ProjectMaintenance < ApplicationRecord
  include HasSeason

  belongs_to :project
  belongs_to :user

  validates :project, :user, presence: true
  validates :project_id, uniqueness: { scope: [:season_id, :user_id] }

  before_create :assign_position

  default_scope -> { order(:position) }

  private

  # Add new project maintainers to the end of the list
  def assign_position
    prio_scope = { project_id: project_id, season_id: season_id }
    self.position = if prio = self.class.where(prio_scope).maximum(:position)
                      prio + 1
                    else
                      0
                    end
  end
end
