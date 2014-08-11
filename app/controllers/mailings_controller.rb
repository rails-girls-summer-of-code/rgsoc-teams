class MailingsController < ApplicationController
  before_filter :normalize_params, only: [:create, :update]
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

  def index
    authorize! :read, :mailing
  end

  def show
    authorize! :read, :mailing
  end

  private

    def set_mailings
      @mailings = Mailing.order('id DESC').page(params[:page])
    end

    def set_mailing
      @mailing = params[:id] ? Mailing.find(params[:id]) : Mailing.new(mailing_params)
    end

    def normalize_params
      params[:mailing][:to] = params[:mailing][:to].select(&:present?)
    end

    def mailing_params
      if params[:mailing]
        self.params.require(:mailing).permit(:from, :cc, :bcc, :subject, :body, to: [])
      else
        { from: ENV['EMAIL_FROM'], to: 'teams' }
      end
    end
end
