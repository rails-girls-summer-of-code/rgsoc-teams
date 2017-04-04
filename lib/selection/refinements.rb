module Selection
  module Refinements
    module StringMathExtensions
      refine String do
        def to_rad
          self.to_f * Math::PI / 180
        end
      end
    end
  end
end
