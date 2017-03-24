class Application < ActiveRecord::Base
  class Data < Struct.new(:data, :role, :subject)
    ORDER = [
      nil,

      :student0_name, :student1_name,
      :student0_application_age, :student1_application_age,
      :student0_application_gender_identification, :student1_application_gender_identification,
      :student0_application_diversity, :student1_application_diversity,
      :student0_application_location, :student1_application_location,
      :student0_application_about, :student1_application_about,
      :student0_application_code_background, :student1_application_code_background,
      :student0_application_skills, :student1_application_skills,
      :student0_application_coding_level, :student1_application_coding_level,
      :student0_application_community_engagement, :student1_application_community_engagement,
      :student0_application_giving_back, :student1_application_giving_back,
      :student0_application_language_learning_period, :student1_application_language_learning_period,
      :student0_application_learning_history, :student1_application_learning_history,
      :student0_application_code_samples, :student1_application_code_samples,
      :student0_application_goals, :student1_application_goals,
      :student0_application_motivation, :student1_application_motivation,
      :student0_application_money, :student1_application_money,
      :student0_application_minimum_money, :student1_application_minimum_money,
      :project1_id, :project2_id,
      :why_selected_project1, :why_selected_project2,
      :plan_project1, :plan_project2,
      :working_together,
      :voluntary, :voluntary_hours_per_week,
      :heard_about_it,
      :misc_info,

    ]

    def extract
      sort(data.slice(*keys))
    end

    def keys
      case role
      when :student     then data.keys.grep(/^#{role}#{student_ix}/)
      when :team        then data.keys.grep(/(voluntary|heard_about|coaches_hours|team)/)
      when :application then data.keys.grep(/(project)/)
      else raise("Unknown role for Application::Data: #{role}")
      end
    end

    def student_ix
      handle = subject.github_handle.downcase.gsub(/\d/, '')
      name = subject.name.downcase.gsub(/\d/, '')
      key = ['student0_name', 'student1_name'].detect do |key|
        value = data[key].downcase
        handle.include?(value) || name.include?(value) || value.include?(handle) || value.include?(name)
      end
      key.gsub(/\D/, '') if key
    end

    def sort(data)
      keys = data.keys.map(&:to_sym).sort { |lft, rgt| (ORDER.index(lft) || 99) <=> (ORDER.index(rgt) || 99) }
      keys.map(&:to_s).inject({}) { |result, key| result.merge(key => data[key]) }
    end
  end

  include HasSeason, Rateable

  belongs_to :application_draft
  belongs_to :team, inverse_of: :applications, counter_cache: true
  belongs_to :project

  has_many :todos, dependent: :destroy
  has_many :ratings, as: :rateable

  validates :team, :application_data, presence: true

  PROJECT_VISIBILITY_WEIGHT = ENV['PROJECT_VISIBILITY_WEIGHT'] || 2
  COACHING_COMPANY_WEIGHT = ENV['COACHING_COMPANY_WEIGHT'] || 2
  MENTOR_PICK_WEIGHT = ENV['MENTOR_PICK_WEIGHT'] || 2
  FLAGS = [:remote_team,
          :mentor_pick,
          :volunteering_team,
          :selected,
          :male_gender,
          :zero_community,
          :age_below_18,
          :less_than_two_coaches]

  FIELDS_REMOVED_IN_BLIND = [:student0_name,
                             :student1_name,
                             :student0_application_minimum_money,
                             :student1_application_minimum_money,
                             :student0_application_money,
                             :student1_application_money,
                             :student0_application_location,
                             :student1_application_location,
                             :student0_application_age,
                             :student1_application_age,
                             :voluntary,
                             :voluntary_hours_per_week,
                             :heard_about_it,
                             :student0_application_location,
                             :student1_application_location]

  has_many :comments, -> { order(:created_at) }, as: :commentable, dependent: :destroy

  scope :hidden, -> { where('applications.hidden IS NOT NULL and applications.hidden = ?', true) }
  scope :visible, -> { where('applications.hidden IS NULL or applications.hidden = ?', false) }

  def self.data_label(key)
    ApplicationDraft.human_attribute_name(key)
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
    application_data['location']
  end

  def minimum_money
    application_data['minimum_money']
  end

  def data_for(role, subject)
    Data.new(application_data, role, subject).extract || {}
  end

  def sorted_application_data
    d = Data.new
    d.sort(application_data)
  end

  def blinded_sorted_application_data
    allowed_keys =  sorted_application_data.keys.map(&:to_sym) - FIELDS_REMOVED_IN_BLIND
    allowed_keys.inject({}) { |result, key| result.merge(key => application_data[key.to_s]) }
  end

  def average_skill_level
    skill_levels = ratings.map {|rating| rating.data['skill_level'] }.compact
    !skill_levels.empty? ? skill_levels.inject(:+) / skill_levels.size : 0
  end

  def total_picks
    ratings.where(pick: true).count
  end

  def combined_ratings
    ratings.to_a + team.combined_ratings
  end

  def sponsor_pick?
    sponsor_pick.present?
  end

  FLAGS.each do |flag|
    define_method(flag) { flags.include?(flag.to_s) }
    alias_method :"#{flag}?", flag

    define_method :"#{flag}=" do |value|
      flags_will_change!
      value.to_s != '0' ? flags.concat([flag.to_s]).uniq : flags.delete(flag.to_s)
    end
  end

  def student_skill_level
    application_data['student0_application_coding_level'].try(:to_i)
  end

  def pair_skill_level
    application_data['student1_application_coding_level'].try(:to_i)
  end
end
