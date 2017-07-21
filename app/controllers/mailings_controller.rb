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

end
