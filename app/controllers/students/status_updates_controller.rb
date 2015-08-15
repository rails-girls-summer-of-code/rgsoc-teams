class Students::StatusUpdatesController < Students::BaseController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def index
     #order = DESC; set in model
    @status_updates = current_team.status_updates.ordered
    @status_update = current_team.status_updates.build
  end

  def create
    @status_update = current_team.status_updates.build(
      status_update_params.merge(published_at: Time.now.utc)
    )
    if @status_update.save
      flash[:notice] = 'Status Update created'
    else
      flash[:danger] = 'Fill in the blank fields'
    end
    redirect_to action: :index
  end

  def show
  end

  def edit
  end

  def update
    if @status_update.update(status_update_params)
      flash[:notice] = 'Status Update updated'
      redirect_to action: :index
    else
      render :edit
    end
  end

  def destroy
    if @status_update.destroy
      flash[:notice] = 'Status Update has been deleted'
    else
      flash[:alert]  = 'An error occurred while deleting your status update'
    end
    redirect_to action: :index
  end

  protected

  def find_resource
    @status_update = current_team.status_updates.find params[:id]
  end

  def status_update_params
    params.require(:activity).permit(:title, :content)
  end

end