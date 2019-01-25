# frozen_string_literal: true

class StudentsController < ApplicationController
  after_action :cors_set_headers, only: :index

  respond_to :json

  def index
    @students = User.with_role("student").includes(roles: :team).
      where("teams.season_id = ? and teams.kind IS NOT NULL", Season.current).
      references(:teams).distinct
    respond_with @students.as_json(json_params)
  end

  private

  def json_params
    {
      only: [:github_handle, :avatar_url, :location, :country, :twitter_handle],
      methods: [:name_or_handle],
      include: [
        roles: {
          only: [:name],
          include: [team: { only: [:id, :name, :kind] }]
        }
      ]
    }
  end
end
