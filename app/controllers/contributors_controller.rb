class ContributorsController < ApplicationController
  after_action :cors_set_headers, only: :index

  respond_to :json

  def index
    @contributors = User.with_role(Role::CONTRIBUTOR_ROLES).uniq
    respond_with @contributors.as_json(json_params)
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
