# frozen_string_literal: true
module HasSeason
  extend ActiveSupport::Concern

  included do
    belongs_to :season
  end
end
