class RatingData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  FIELDS = HashWithIndifferentAccess.new({
    women_priority: [
      { id: 0, points: 0, human: '2 women pair' },
      { id: 1, points: 1, human: 'mixed pair or single women' },
      { id: 2, points: 5, human: 'men pair' },
    ],
    skill_level: [
      { id: 0, points: 10, human: '5: Is used to refactoring' },
      { id: 1, points:  6, human: '4: Has contributed to Open Source' },
      { id: 2, points:  3, human: '3: Can write a unit test' },
      { id: 3, points:  1, human: '2: Can write a method' },
      { id: 4, points:  0, human: '1: Knows data types' },
    ],
    practice_time: [
      { id: 0, points: 10, human: 'more than 12 months' },
      { id: 1, points:  6, human: '9-12 months' },
      { id: 2, points:  3, human: '6-9 months' },
      { id: 3, points:  2, human: '3-6 months' },
      { id: 4, points:  1, human: '1-3 months' },
      { id: 5, points:  0, human: 'less than a month' },
    ],
    support: [
      { id: 0, points: 10, human: 'fulltime support' },
      { id: 1, points:  8, human: '5-6 hours a day' },
      { id: 2, points:  6, human: '3-4 hours a day' },
      { id: 3, points:  4, human: '1-2 hours a day' },
      { id: 4, points:  2, human: '1 hour a day' },
    ],
    planning: [
      { id: 0, points: 10, human: 'has a proper project plan' },
      { id: 1, points:  6, human: 'weak plan, project only vaguely mentioned' },
      { id: 2, points:  0, human: 'project undecided, no plan' },
    ],

    project_time: [],
    bonus: 'numeric',
    is_woman: [],
    min_money: [],
  })

  attr_accessor *FIELDS.keys

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
    # define <field>_options methods for all fields
    # (to be used by forms to create select tags)
    FIELDS.each do |name, options|
      define_singleton_method "#{name}_options" do
        options.try(:map) { |o| [o[:id], o[:human] ] } || []
      end
    end
  end

  def self.points_for( field_name:, id_picked: )
    case FIELDS[field_name]
    when nil
      raise ArgumentError, 'field_name not defined'
    when 'numeric'
      id_picked
    else
      FIELDS[field_name].detect{|h| h[:id] == id_picked}.try(:[], :points)
    end
  end
end
