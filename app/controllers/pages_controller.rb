# frozen_string_literal: true

class PagesController < ApplicationController
  LAYOUTS = {
    help: 'help'
  }

  def show
    render page, layout: layout
  end

  private

  def page
    params[:page].split('/').last
  end

  def layout
    LAYOUTS[params[:page].to_sym] || 'application'
  end
end
