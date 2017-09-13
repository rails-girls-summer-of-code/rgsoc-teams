module CommunityHelper
  def interested_in_field(user)
    return unless user.present?
    interests = user.interested_in.map { |key| User::INTERESTS[key].presence }.compact.join(', ') 
    interest_others = user.try(:interested_in_other)
    content_tag(:p, interests) + content_tag(:p, interest_others)
  end
end