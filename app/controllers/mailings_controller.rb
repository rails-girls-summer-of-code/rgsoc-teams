class MailingsController < ApplicationController
  before_filter :set_mailings, only: :index
  before_filter :set_mailing, except: :index

  load_and_authorize_resource

  def create
    if @mailing.save
      redirect_to @mailing, notice: 'Mailing was successfully created.'
    else
      render action: :new
    end
  end

  def update
    if @mailing.update_attributes(mailing_params)
      redirect_to @mailing, notice: 'Mailing was successfully updated.'
    else
      render action: :edit
    end
  end

  def destroy
    @mailing.destroy
    redirect_to mailings_url
  end

  private

    def set_mailings
      @mailings = Mailing.order(:sent_at).page(params[:page])
    end

    def set_mailing
      @mailing = params[:id] ? Mailing.find(params[:id]) : Mailing.new(mailing_params)
    end

    def mailing_params
      if params[:mailing]
        params.require(:mailing).permit(:from, :to, :cc, :bcc, :subject, :body)
      else
        { from: ENV['EMAIL_FROM'], to: 'teams' }
      end
    end
end
