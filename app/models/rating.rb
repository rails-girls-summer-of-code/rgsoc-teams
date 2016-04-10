class Rating < ActiveRecord::Base
  class Calc
    TYPES = { truncated: :mean, weighted: :wma }

    attr_reader :subject, :type, :options

    def initialize(subject, type = :mean, options = {})
      @subject = subject
      @type = type
      @options = options
    end

    def calc
      values = by_user.map(&:mean)
      # p [subject.class.name, values].flatten
      values.empty? ? 0 : values.send(TYPES[type] || type).round_to(1)
    end

    private

      def by_user
        groups = ratings.group_by(&:user_id).values
        # groups.map { |ratings| ratings.map { |rating| rating.values(options) }.flatten }
        groups.map { |ratings| ratings.map { |rating| rating.value(options) }.flatten }
      end

      def ratings
        case subject
        when Application
          subject.ratings + subject.team.ratings + subject.team.students.map(&:ratings).flatten
        when Team
          subject.ratings + subject.students.map(&:ratings).flatten
        when User
          subject.ratings
        end
      end
  end

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

  serialize :data

  belongs_to :application
  belongs_to :user
  belongs_to :rateable, polymorphic: true

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
