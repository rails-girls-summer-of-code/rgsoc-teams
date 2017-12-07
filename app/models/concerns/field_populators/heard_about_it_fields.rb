# frozen_string_literal: true

module FieldPopulators
  module HeardAboutItFields
    DIRECT_OUTREACH_CHOICES = %w[
      RGSoC\ Blog
      RGSoC\ Twitter
      RGSoC\ Facebook
      RGSoC\ Newsletter
      RGSoC\ Organisers
    ]

    PARTNER_CHOICES = %w[
      Past\ RGSoC participants
      Another\ diversity\ initiative\ outreach
      Study\ group\ or\ Workshop
      Conference
    ]

    OTHER_CHOICES = %w[
      Friends
      Mass\ media
    ]

    ALL_CHOICES = DIRECT_OUTREACH_CHOICES + PARTNER_CHOICES + OTHER_CHOICES
  end
end
