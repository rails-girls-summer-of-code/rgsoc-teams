class ApplicationDraft < ActiveRecord::Base
  belongs_to :season

  before_validation :set_current_season

  private

  def set_current_season
    self.season ||= Season.current
  end
end
