# frozen_string_literal: true

module Organizers
  class SubmissionsController < Organizers::BaseController
    before_action :find_mailing

    def new
      @submission = Submission.new(mailing: @mailing)
    end

    def create
      @mailing.submit
      redirect_to organizers_mailing_path(@mailing), flash: { notice: 'Submitting.' }
    end

    def update
      @submission = @mailing.submissions.find(params[:id])
      @submission.enqueue
      redirect_to organizers_mailing_path(@mailing), flash: { notice: 'Resubmitting.' }
    end

    private

    def find_mailing
      @mailing = Mailing.find(params[:mailing_id])
    end
  end
end
