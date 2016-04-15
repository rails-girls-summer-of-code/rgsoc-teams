class Rating < ActiveRecord::Base

  serialize :data

  belongs_to :application
  belongs_to :user
  belongs_to :rateable, polymorphic: true

  FIELDS = HashWithIndifferentAccess.new({
    diversity: RatingCriterium.new( 0.05, { 10 => "super diverse", 0 => "not diverse at all" } ),
    skills: RatingCriterium.new( 0.15 ),
    community_involvement: RatingCriterium.new( 0.15 ),
    ambitions: RatingCriterium.new( 0.15),
    ability_to_work_independently: RatingCriterium.new( 0.10 ),
    ability_to_finish_projects: RatingCriterium.new( 0.15 ),
    motivation_for_the_program: RatingCriterium.new( 0.10 ),
    support: RatingCriterium.new( 0.05 ),
    personal_impression: RatingCriterium.new( 0.05 )
  })

  FIELDS.each do |name, rating_criterium|
    define_singleton_method "#{name}_options" do
      rating_criterium.point_options
    end

    define_method name do
      if data.present?
        data[name]
      else
        nil
      end
    end

    define_method "#{name}=" do |value|
      data[name] = value
    end
  end

  before_validation :set_data

  validates :user, :rateable, presence: true
  validates :user, uniqueness: { scope: :rateable }

  class << self
    def user_names
      # may eventually change this to work with users instead of strings
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

  def woman?
    data[:is_woman] == 1
  end

  # public: The weighted sum of the points that the reviewer gave.
  def points
    weighted_points = FIELDS.map do |name, rating_criterium|
      rating_criterium.weighted_points(self.send(name))
    end

    weighted_points.sum
  end

  private
    def set_data
      new_data = {}
      FIELDS.keys.each do |name|
        points = self.send(name)
        new_data = new_data.merge({ name => points })
      end

      self.data = new_data
    end
end
