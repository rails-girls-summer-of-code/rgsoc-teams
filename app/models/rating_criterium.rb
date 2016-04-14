class RatingCriterium
  attr_reader :weight

  MIN_POINTS = 0
  MAX_POINTS = 10

  def initialize(weight, point_names = {})
    if !weight.is_a? Numeric || ( weight < 0 || weight > 1 )
      raise ArgumentError.new("weight must be a number betweent 0 and 1.")
    end

    if !point_names.is_a? Hash
      raise ArgumentError.new("points must be a hash.")
    end

    @weight = weight
    @point_names = point_names
  end

  def point_options
    @point_options ||= (MIN_POINTS..MAX_POINTS).map do |points|
      if @point_names[points]
        name = points.to_s + " - " + @point_names[points]
      else
        name = points.to_s
      end

      name
    end
  end

  def weighted_points(points)
    points * @weight
  end
end