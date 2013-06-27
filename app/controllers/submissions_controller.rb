class SubmissionsController < ApplicationController
  before_filter :set_mailing

  load_and_authorize_resource

  def new
    @submission = Submission.new(mailing: @mailing)
  end

  def create
    @mailing.submit
    redirect_to @mailing, flash: { notice: 'Submission successfully created' }
  end

  private

    def set_mailing
      @mailing = Mailing.find(params[:mailing_id])
    end
end

