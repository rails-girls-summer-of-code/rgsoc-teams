class ProjectsController < ApplicationController

  before_action :login_required, only: [:new]

  def new
  end

  def index
    @projects = Project.all
  end

end
