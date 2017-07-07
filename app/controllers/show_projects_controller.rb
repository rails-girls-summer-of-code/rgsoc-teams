class ShowProjectsController < ApplicationController
  
  def index
    @projects = Project.in_current_season.where(aasm_state: :accepted)
  end
end
