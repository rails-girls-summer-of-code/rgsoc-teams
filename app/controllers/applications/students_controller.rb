class Applications::StudentsController < ApplicationController
  before_action :authenticate_user!
  before_filter -> { require_role 'reviewer' }, except: [:new, :create]
  respond_to :html

  def show
    @student = User.find(params[:id])
    @applications = @student.applications
    @rating = @student.ratings.where(user: current_user).first_or_initialize
    @data = RatingData.new(@rating.data)
  end
end
