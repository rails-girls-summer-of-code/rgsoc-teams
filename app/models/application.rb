class Application < ActiveRecord::Base
  include HasSeason, Rateable

  belongs_to :application_draft
  belongs_to :team, inverse_of: :applications, counter_cache: true
  belongs_to :project

  has_many :todos, dependent: :destroy

  validates :team, :application_data, presence: true

  PROJECT_VISIBILITY_WEIGHT = ENV['PROJECT_VISIBILITY_WEIGHT'] || 2
  COACHING_COMPANY_WEIGHT = ENV['COACHING_COMPANY_WEIGHT'] || 2
  MENTOR_PICK_WEIGHT = ENV['MENTOR_PICK_WEIGHT'] || 2
  FLAGS = [:remote_team,
          :volunteering_team,
          :selected,
          :male_gender,
          :zero_community,
          :age_below_18,
          :less_than_two_coaches,
          :less_than_40_hours_a_week]

  has_many :comments, -> { order(:created_at) }, as: :commentable, dependent: :destroy

  scope :hidden, -> { where('applications.hidden IS NOT NULL and applications.hidden = ?', true) }
  scope :visible, -> { where('applications.hidden IS NULL or applications.hidden = ?', false) }

  def self.data_label(key)
    ApplicationDraft.human_attribute_name(key)
  end

  def data
    ApplicationData.new(self.application_data)
  end
  
  def self.rateable
    joins("LEFT JOIN projects p1 ON p1.id::text = applications.application_data -> 'project1_id'")
      .joins("LEFT JOIN projects p2 ON p2.id::text = applications.application_data -> 'project2_id'")
      .includes(:ratings, :team)
      .where(season: Season.current)
      .where.not(team: nil)
  end

  def name
    [team.try(:name), project.try(:name)].reject(&:blank?).join(' - ')
  end

  def team_name
    team.name
  end

  def student_name
    team.students.first.try(:name)
  end

  def country
    @country ||= super.present? ? super : (team || Team.new).students.map(&:country).reject(&:blank?).join(', ')
  end

  def location
    data.location
  end

  def minimum_money
    data.minimum_money
  end

  FLAGS.each do |flag|
    define_method(flag) { flags.include?(flag.to_s) }
    alias_method :"#{flag}?", flag

    define_method :"#{flag}=" do |value|
      flags_will_change!
      value.to_s != '0' ? flags.concat([flag.to_s]).uniq : flags.delete(flag.to_s)
    end
  end

  def project1
    Project.find_by(id: application_data['project1_id'])
  end

  def project2
    Project.find_by(id: application_data['project2_id'])
  end
end
