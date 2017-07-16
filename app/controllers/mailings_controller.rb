class MailingsController < ApplicationController
  before_action :normalize_params, only: [:create, :update]
  before_action :set_mailings, only: :index
  before_action :set_mailing, only: :show

  load_and_authorize_resource

  def index
    authorize! :read, :mailing
  end

  def show
    authorize! :read, :mailing
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

  def set_mailings
    @mailings = Mailing.order('id DESC').page(params[:page])
  end

  def set_mailing
    @mailing = Mailing.find(params[:id])
  end

  def normalize_params
    params[:mailing][:to] = params[:mailing][:to].select(&:present?)
  end

  def mailing_params
    if params[:mailing]
      self.params.require(:mailing)
        .permit(:group, :from, :cc, :bcc, :subject, :body, to: [], seasons: [])
    else
      { from: ENV['EMAIL_FROM'], to: 'teams', seasons: [Season.current.name] }
    end
  end
end
