class RepositoriesController < ApplicationController
  before_filter :set_team
  before_filter :set_repository, except: [:index, :new]

  load_and_authorize_resource except: [:index, :show]

  def index
    @repositories = @team.repositories
  end

  def new
    @repository = Repository.new
  end

  def create
    respond_to do |format|
      if @repository.save
        format.html { redirect_to @team, notice: 'Repository was successfully created.' }
        format.json { render action: :show, status: :created, location: @team }
      else
        format.html { render action: :new }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @repository.update_attributes(repository_params)
        format.html { redirect_to @team, notice: 'Repository was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @repository.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @repository.destroy
    respond_to do |format|
      format.html { redirect_to @team }
      format.json { head :no_content }
    end
  end


  private

    def set_team
      @team = Team.find(params[:team_id])
    end

    def set_repository
      @repository = if params[:id]
        @team.repositories.find(params[:id])
      else
        @team.repositories.build(repository_params)
      end
    end

    def repository_params
      params.require(:repository).permit(:url)
    end
end
