# frozen_string_literal: true

class MailingsController < ApplicationController
  load_and_authorize_resource

  def index
    @mailings = Mailing.order('id DESC').page(params[:page])
  end

  # These actions are here to enable the cancancan 'not authorised' notice
  # instead of a Rails exception.
  def show; end

  def new; end

  def edit; end
end
