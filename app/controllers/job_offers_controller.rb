class JobOffersController < ApplicationController
  load_and_authorize_resource

  helper_method :job_offer, :job_offers

  private

  def job_offer
    @job_offer ||= params[:id] ? JobOffer.find(params[:id]) : JobOffer.new(job_offer_params)
  end

  def job_offers
    # TODO sorting
    @job_offers ||= JobOffer.all
  end
end
