class JobOffersController < ApplicationController
  load_and_authorize_resource

  helper_method :job_offer, :job_offers

  def create
    job_offer.save!
    redirect_to job_offer
  end

  def update
    job_offer.update_attributes(job_offer_params)
    redirect_to job_offer
  end

  def destroy
    job_offer.destroy!
    redirect_to job_offers_path
  end

  private

  def job_offer
    @job_offer ||= params[:id] ? JobOffer.find(params[:id]) : JobOffer.new(job_offer_params)
  end

  def job_offers
    # TODO sorting
    @job_offers ||= JobOffer.all
  end

  def job_offer_params
    if params[:job_offer]
      params.require(:job_offer).permit(
        :company_name, :contact_email, :contact_name,
        :contact_phone, :description, :duration,
        :location, :misc_info, :paid,
        :public, :title, :url
      )
    else
      {}
    end
  end

end
