# frozen_string_literal: true

class Application < ApplicationRecord
  include Rateable
  include HasSeason

  PROJECT_VISIBILITY_WEIGHT = ENV['PROJECT_VISIBILITY_WEIGHT'] || 2
  COACHING_COMPANY_WEIGHT = ENV['COACHING_COMPANY_WEIGHT'] || 2
  MENTOR_PICK_WEIGHT = ENV['MENTOR_PICK_WEIGHT'] || 2

  belongs_to :application_draft
  belongs_to :team, inverse_of: :applications, counter_cache: true
  belongs_to :project, optional: true

  has_many :comments, -> { order(:created_at) }, as: :commentable, dependent: :destroy

  validates :application_data, presence: true

  before_validation :remove_duplicate_flags

  scope :hidden, -> { where('applications.hidden IS NOT NULL and applications.hidden = ?', true) }
  scope :visible, -> { where('applications.hidden IS NULL or applications.hidden = ?', false) }

  def self.data_label(key)
    ApplicationDraft.human_attribute_name(key)
  end

  def self.rateable
    joins("LEFT JOIN projects p1 ON p1.id::text = applications.application_data -> 'project1_id'")
      .joins("LEFT JOIN projects p2 ON p2.id::text = applications.application_data -> 'project2_id'")
      .includes(:ratings, :team)
      .where(season: Season.current)
      .where.not(team: nil)
  end

  def data
    ApplicationData.new(application_data)
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
    @country ||= super.presence || (team || Team.new).students.map(&:country).reject(&:blank?).join(', ')
  end

  def location
    data.location
  end

  def minimum_money
    data.minimum_money
  end

  Selection::Table::FLAGS.each do |flag|
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

  private

  def remove_duplicate_flags
    flags.uniq!
  end
end
