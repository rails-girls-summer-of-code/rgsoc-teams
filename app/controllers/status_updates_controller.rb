class StatusUpdatesController < ApplicationController
  def show
    @status_update = Activity.with_kind('status_update').find params[:id]
  end
end
