require 'csv'

class Rating::ApplicationsController < Rating::BaseController
  before_action :store_filters, only: :index
  before_action :persist_order, only: :index
  respond_to :html

  PATH_PARENTS = [:rating]

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Applications', [:rating, :applications] ]
  end

  def index
    @table = applications_table
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = 'attachment; filename="rating-applications.csv"'
        headers['Content-Type']        = 'text/csv'
      end
    end
  end

  def show
    @application = Application.includes(:team, :project, :comments).find(params[:id])
    @rating = @application.ratings.find_or_initialize_by(user: current_user)
    @breadcrumbs << ["Application ##{@application.id}", (self.class::PATH_PARENTS + [@application])]
  end

  def edit
    @application = Application.find(params[:id])

    @breadcrumbs << ["Application ##{@application.id}", (self.class::PATH_PARENTS + [@application])]
    @breadcrumbs << ["Edit additional info", [:edit] + self.class::PATH_PARENTS + [@application]]

    @form_path = self.class::PATH_PARENTS + [@application]
  end

  def update
    @application = Application.find(params[:id])
    if @application.update(application_params)
      redirect_to self.class::PATH_PARENTS + [@application]
    else
      render :edit
    end
  end

  private

  def application_params
    params.require(:application).
      permit(:misc_info,
            :project_id,
            :city,
            :country,
            :coaching_company,
            Application::FLAGS)
  end

  def store_filters
    Rating::Table::FLAGS.each do |key|
      key = :"hide_#{key}"
      session[key] = params[:filter][key] == 'true' if params[:filter] && params[:filter].key?(key)
    end
  end

  def order
    params[:order] || session[:order] || :id
  end

  def persist_order
    session[:order] = params[:order] if params[:order]
  end

  def applications_table
    options = { order: order, hide_flags: [] }
    Rating::Table::FLAGS.each do |flag|
      options[:hide_flags] << flag.to_s if session[:"hide_#{flag}"]
    end
    Rating::Table.new(applications: Application.rateable, options: options)
  end
end
