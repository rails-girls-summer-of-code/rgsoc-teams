module RatingsHelper
  def rounded_points_for(subject, precision=2)
    points = subject.try(:average_points) || subject.try(:points)
    points.round precision if points
  end
end
