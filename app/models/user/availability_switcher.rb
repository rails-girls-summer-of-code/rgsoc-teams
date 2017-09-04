# frozen_string_literal: true

class User::AvailabilitySwitcher

  def self.reset
    User.with_role('coach').update_all(availability: false)
  end
end