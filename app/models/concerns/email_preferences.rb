# frozen_string_literal: true

module EmailPreferences
  include ActiveSupport::Concern

  ATTRIBUTES = [
    :opted_in_newsletter,
    :opted_in_announcements,
    :opted_in_marketing_announcements,
    :opted_in_surveys,
    :opted_in_sponsorships,
    :opted_in_applications_open
  ]

  ATTRIBUTES.each do |attribute|
    define_method attribute do
      public_send("#{attribute}_at?")
    end

    define_method "#{attribute}?" do
      public_send(attribute)
    end

    define_method "#{attribute}=" do |value|
      accepted = ActiveRecord::Type::Boolean.new.cast(value)
      if accepted
        public_send("#{attribute}_at=", (send("#{attribute}_at") || Time.now))
      else
        public_send("#{attribute}_at=", nil)
      end
    end
  end
end
