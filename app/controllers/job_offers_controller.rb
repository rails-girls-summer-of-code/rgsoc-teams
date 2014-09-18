class JobOffersController < ApplicationController

  helper_method :job_offers

  private

  def job_offers
    @job_offers ||= JobOffer.all
  end
end
