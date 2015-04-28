module TodoHelper
  def rating(model)
    ratings.find do |rating|
      rating.rateable_type == model.class.name && rating.rateable_id == model.id
    end
  end

  private

  def ratings
    @ratings ||= Rating.where(user: current_user)
  end
end
