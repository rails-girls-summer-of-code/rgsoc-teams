class SourcesController < ApplicationController
  before_filter :set_team
  before_filter :set_source, except: [:index]

  load_and_authorize_resource except: [:index, :show]

  def index
    @sources = @team.sources
  end

  def new
    @source = Source.new
  end

  def create
    respond_to do |format|
      if @source.save
        format.html { redirect_to @team, notice: 'Source was successfully created.' }
        format.json { render action: :show, status: :created, location: @team }
      else
        format.html { render action: :new }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @source.update_attributes(source_params)
        format.html { redirect_to @team, notice: 'Source was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @source.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @source.destroy
    respond_to do |format|
      format.html { redirect_to @team }
      format.json { head :no_content }
    end
  end


  private

    def set_team
      @team = Team.find(params[:team_id])
    end

    def set_source
      @source = if params[:id]
        @team.sources.find(params[:id])
      else
        @team.sources.new(source_params)
      end
    end

    def source_params
      params[:source] ||= { url: params[:url] }
      params.require(:source).permit(:url)
    end
end
