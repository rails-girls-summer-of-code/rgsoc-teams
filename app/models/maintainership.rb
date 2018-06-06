# frozen_string_literal: true

class Maintainership < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :user, optional: true

  validates :project, :user, presence: true
  validates :project_id, uniqueness: { scope: :user_id }
end
