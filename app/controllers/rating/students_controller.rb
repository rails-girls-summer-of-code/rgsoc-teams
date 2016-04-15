class Rating::StudentsController < Rating::BaseController
  respond_to :html

  def show
    @student = User.find(params[:id])
    @applications = @student.applications
    @rating = @student.ratings.where(user: current_user).first_or_initialize
  end
end
