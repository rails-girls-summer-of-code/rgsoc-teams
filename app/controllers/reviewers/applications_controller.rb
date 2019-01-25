# frozen_string_literal: true

require 'csv'

module Reviewers
  class ApplicationsController < Reviewers::BaseController
    before_action :store_filters, only: :index
    before_action :persist_order, only: :index
    helper_method :mentor_comments
    respond_to :html

    PATH_PARENTS = [:reviewers]

    def set_breadcrumbs
      super
      @breadcrumbs << ['Applications', [:reviewers, :applications]]
    end

    def index
      @table = applications_table
      @strictness = Selection::Strictness.in_current_season
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
              Selection::Table::FLAGS)
    end

    def store_filters
      Selection::Table::FLAGS.each do |key|
        session[key] = params[:filter][key] == 'true' if params.dig(:filter, key)
      end
    end

    def mentor_comments
      Mentor::Comment.where(commentable_id: @application.id).where('created_at >= ?', Date.parse('2018.02.28'))
    end

    def persist_order
      session[:order] = params[:order].to_sym if params[:order]
    end

    def applications_table
      options = {
        order:      session[:order],
        hide_flags: Selection::Table::FLAGS.select { |f| session[f] }
      }
      Selection::Table.new(applications: Application.rateable, options: options)
    end
  end
end
