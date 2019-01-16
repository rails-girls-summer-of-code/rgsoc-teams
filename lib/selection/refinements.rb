# frozen_string_literal: true

module Selection
  module Refinements
    module StringMathExtensions
      refine String do
        def to_rad
          to_f * Math::PI / 180
        end
      end
    end
  end
end
