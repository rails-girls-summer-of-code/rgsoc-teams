class TeamsController < ApplicationController
  before_filter :set_team,  only: [:show, :edit, :update, :destroy]
  before_filter :set_users, only: [:new, :edit]

  def index
    @teams = Team.order(:id)
  end

  def show
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to @team, notice: 'Team was successfully created.' }
        format.json { render action: :show, status: :created, location: @team }
      else
        format.html { render action: :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update_attributes(team_params)
        format.html { redirect_to @team, notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url }
      format.json { head :no_content }
    end
  end


  private

    def set_team
      @team = Team.find(params[:id])
    end

    def set_users
      @users = User.order(:github_handle)
    end

    def team_params
      params.require(:team).permit(:bio, :email, :homepage, :location, :name, :role)
    end
end
