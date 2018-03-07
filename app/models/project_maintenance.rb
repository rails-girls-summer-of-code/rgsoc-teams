# frozen_string_literal: true

class ProjectMaintenance < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :project, :user, presence: true
  validates :project_id, uniqueness: { scope: :user_id }

  before_create :assign_position

  default_scope -> { order(:position) }

  private

  # Add new project maintainers to the end of the list
  def assign_position
    self.position = if prio = self.class.where(project_id: project_id).maximum(:position)
                      prio + 1
                    else
                      0
                    end
  end
end
