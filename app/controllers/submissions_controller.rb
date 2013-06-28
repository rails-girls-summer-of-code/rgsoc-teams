class SubmissionsController < ApplicationController
  before_filter :set_mailing
  before_filter :set_submission, only: :update

  load_and_authorize_resource

  def new
    @submission = Submission.new(mailing: @mailing)
  end

  def create
    @mailing.submit
    redirect_to @mailing, flash: { notice: 'Submitting.' }
  end

  def update
    @submission.enqueue
    redirect_to @mailing, flash: { notice: 'Resubmitting.' }
  end

  private

    def set_mailing
      @mailing = Mailing.find(params[:mailing_id])
    end

    def set_submission
      @submission = @mailing.submissions.find(params[:id])
    end
end

