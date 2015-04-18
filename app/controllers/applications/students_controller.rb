class Applications::StudentsController < ApplicationController
  # include ApplicationsHelper

  # before_filter :store_filters, only: :index
  # before_filter :persist_order, only: :index
  # before_filter :checktime, only: [:new, :create]
  before_action :authenticate_user!
  before_filter -> { require_role 'reviewer' }, except: [:new, :create]
  respond_to :html

  def show
    @student = User.find(params[:id])
    @applications = @student.applications
    @rating = @student.ratings.where(user: current_user).first_or_initialize
    @data = RatingData.new(@rating.data)

    # unless @application.hidden
    #   @prev = prev_application
    #   @next = next_application
    # end
  end
end
