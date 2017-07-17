class Orga::SubmissionsController < Orga::BaseController
  before_action :find_mailing
  before_action :set_submission, only: :update

  def new
    @submission = Submission.new(mailing: @mailing)
  end

  def create
    @mailing.submit
    redirect_to @mailing, flash: { notice: 'Submitting.' }
  end

  def update
    @submission.enqueue
    redirect_to orga_mailing_path(@mailing), flash: { notice: 'Resubmitting.' }
  end

  private

  def find_mailing
    @mailing = Mailing.find(params[:mailing_id])
  end

  def set_submission
    @submission = @mailing.submissions.find(params[:id])
  end
end

