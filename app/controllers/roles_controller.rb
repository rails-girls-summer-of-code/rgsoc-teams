class RolesController < ApplicationController
  before_filter :set_team
  before_filter :set_role, only: :destroy

  def new
    @role = @team.roles.new(name: params[:name])
    @users = User.order(:github_handle)
  end

  def create
    user = find_or_create_user
    @team.roles.create!(name: params[:role][:name], user_id: user.id)
    redirect_to @team
  end

  def destroy
    @role.destroy
    redirect_to @team
  end


  private

    def set_team
      @team = Team.find(params[:team_id])
    end

    def set_role
      @role = @team.roles.find(params[:id])
    end

    def find_or_create_user
      attrs = { github_handle: params[:role][:github_handle] }
      User.where(attrs).first || User.create!(attrs)
    end
end
