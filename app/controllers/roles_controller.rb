class RolesController < ApplicationController
  before_action :set_team
  before_action :set_role, except: [:index, :show]

  load_and_authorize_resource except: [:index, :show]

  def new
    @role = @team.roles.new(name: params[:name])
    @users = User.order(:github_handle)
  end

  def create
    @role.user = User.where(github_handle: params[:role][:github_handle]).first_or_create

    respond_to do |format|
      if @role.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render action: :show, status: :created, location: @team }
      else
        format.html { render action: :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
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
      @role = if params[:id]
        @team.roles.find(params[:id])
      else
        @team.roles.new(role_params)
      end
    end

    def role_params
      params[:role] ||= { name: params[:name] }
      params.require(:role).permit(:user_id, :team_id, :name, :github_handle)
    end

end
