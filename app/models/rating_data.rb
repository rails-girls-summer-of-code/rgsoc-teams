class RatingData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

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

  attr_accessor *FIELDS.keys

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    # define <field>_options methods for all fields
    # (to be used by forms to create select tags)
    FIELDS.each do |name, rating_criterium|
      define_singleton_method "#{name}_options" do
        rating_criterium.point_options
      end
    end
  end

  def self.points_for( field_name: )
    case FIELDS[field_name]
    when nil
      raise ArgumentError, 'field_name not defined'
    else
      FIELDS[field_name].weighted_points
    end
  end
end
