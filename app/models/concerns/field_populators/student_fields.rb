# frozen_string_literal: true

module FieldPopulators
  module StudentFields
    AGE = %w[
      under\ 18
      18-21
      22-30
      31-40
      41-50
      51-60
      over\ 60
    ]

    GENDER_LIST = %w[
      Agender
      Bigender
      Cisgender\ Woman
      Gender\ Fluid
      Gender\ Nonconforming
      Gender\ Questioning
      Genderqueer
      Non-binary
      Female
      Transgender\ Woman
    ]

    MONTHS_LEARNING = %w[
      1-3
      4-6
      7-9
      10-12
      13-24
      24+
      N/A
    ]
  end
end
