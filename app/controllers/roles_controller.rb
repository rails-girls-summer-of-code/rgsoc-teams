class RolesController < ApplicationController
  before_filter :set_team
  before_filter :set_role, only: :destroy

  def new
    @role = @team.roles.new(name: params[:name])
    @users = User.order(:github_handle)
  end

  def create
    @role = @team.roles.new(role_params)

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
      @role = @team.roles.find(params[:id])
    end

    def role_params
      params.require(:role).permit(:user_id, :team_id, :name)
    end

end
