class Rating < ActiveRecord::Base

  serialize :data

  belongs_to :application
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  class << self
    def user_names
      User.find(pluck(:user_id).uniq).map(&:name)
    end

    def excluding(names)
      joins(:user).where('users.name NOT IN (?)', names)
    end

    def by(user)
      where(user_id: user.id)
    end

    def for(type, id)
      where(rateable_type: type, rateable_id: id)
    end
  end

  def data
    Hashr.new(super)
  end

  def woman?
    data[:is_woman] == 1
  end

  # public: The sum of the points that the reviewer gave.
  def points
    values.sum
  end

  def value(options = {})
    values = values(options)
    values.empty? ? 0 : values.mean
  end

  def values(options = {})
    data = self.data.except(:min_money, :is_woman)
    data = data.merge(bonus: data[:bonus] + 10) if options[:bonus_points] && data[:bonus]
    data.map { |key, value| points_for(key, value) }
  end

  private
    def points_for(key, value)
      points = RatingData.points_for(field_name: key, id_picked: value)
    end
end
