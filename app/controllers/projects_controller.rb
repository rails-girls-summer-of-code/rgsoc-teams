class ProjectsController < ApplicationController

  before_action :login_required, only: [:new]

  def new
    @project = Project.new
  end

  def index
    @projects = Project.all
  end

end
