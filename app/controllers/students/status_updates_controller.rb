# frozen_string_literal: true

module Students
  class StatusUpdatesController < Students::BaseController
    before_action :find_resource, only: [:show, :edit, :update, :destroy]
    helper_method :status_updates

    def index
      @status_update = current_team.status_updates.build
    end

    def create
      @status_update = current_team.status_updates.build(
        status_update_params.merge(published_at: Time.now.utc)
      )
      if @status_update.save
        flash[:notice] = 'Status Update created'
        redirect_to action: :index
      else
        render :index
      end
    end

    def preview
      @status_update = current_team.status_updates.build(status_update_params)
      render partial: "preview"
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

    private

    def status_updates
      # order = DESC; set in model
      @status_updates ||= current_team.status_updates.ordered
    end
  end
end
