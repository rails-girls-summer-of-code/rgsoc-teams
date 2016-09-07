module StatusUpdatesHelper
  def links_to_status_updates
    if params[:action]=="edit"
      link_to 'Back', students_status_update_path(@status_update), class: 'btn btn-default'
    end
  end
end