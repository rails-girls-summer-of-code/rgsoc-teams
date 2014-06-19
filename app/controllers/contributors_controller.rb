class ContributorsController < ApplicationController
  respond_to :json

  def index
    @contributors = User.with_role(Role::CONTRIBUTOR_ROLES).uniq
    respond_with @contributors.as_json(json_params)
  end

  private

  def json_params
    {
      only: [:name, :github_handle, :avatar_url, :location, :country],
      include: [
        roles: {
          only: [:name],
          include: [team: { only: [:id, :name, :kind] }]
        }
      ]
    }
  end
end
