# frozen_string_literal: true

require 'selection/refinements'

module Selection
  class Distance
    using Refinements::StringMathExtensions

    RADIUS_OF_EARTH_IN_M = 6371000

    def initialize(from, to)
      @from_lat, @from_lng = from.map { |val| val.to_rad }
      @to_lat,   @to_lng   = to.map { |val| val.to_rad }
    end

    def to_m
      haversine_distance
    end

    def to_km
      to_m / 1000
    end

    private

    attr_reader :from_lat, :from_lng, :to_lat, :to_lng

    def haversine_distance
      a = Math.sin(delta_lat / 2)**2 +
          Math.cos(from_lat) * Math.cos(to_lat) * Math.sin(delta_lng / 2)**2
      c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))

      (c * RADIUS_OF_EARTH_IN_M).round
    end

    def delta_lat
      from_lat - to_lat
    end

    def delta_lng
      from_lng - to_lng
    end
  end
end
