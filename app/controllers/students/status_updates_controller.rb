class Students::StatusUpdatesController < Students::BaseController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def index
    @status_updates = current_team.status_updates.order('created_at DESC')
  end

  def new
    @status_update = current_team.status_updates.build
  end

  def create
    @status_update = current_team.status_updates.build(status_update_params)
    if @status_update.save
      flash[:notice] = "Status Update created"
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @status_update.update(status_update_params)
      flash[:notice] = "Status Update updated"
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    if @status_update.destroy
      flash[:notice] = "Status Update has been deleted"
    else
      flash[:alert]  = "An error occured while deleting your status update"
    end
    redirect_to action: :index
  end

  protected

  def find_resource
    @status_update = current_team.status_updates.find params[:id]
  end

  def status_update_params
    params.require(:status_update).permit(:subject, :body)
  end

end
