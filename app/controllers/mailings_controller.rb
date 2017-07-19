class MailingsController < ApplicationController

  load_and_authorize_resource

  def index
    @mailings = Mailing.order('id DESC').page(params[:page])
    authorize! :read, :mailing
  end

  def show
    @mailing = Mailing.find(params[:id])
    authorize! :read, :mailing
  end

  def new; end
  def edit; end

  private

  def mailing_params
    if params[:mailing]
      self.params.require(:mailing)
        .permit(:group, :from, :cc, :bcc, :subject, :body, to: [], seasons: [])
    else
      { from: ENV['EMAIL_FROM'], to: 'teams', seasons: [Season.current.name] }
    end
  end
end
