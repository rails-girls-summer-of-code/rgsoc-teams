# frozen_string_literal: true
class User::AvailabilitySwitcher
  def self.reset!
    User.with_interest('coach').update_all(availability: false)
  end
end