# frozen_string_literal: true

class Rating < ApplicationRecord
  FIELDS = ActiveSupport::HashWithIndifferentAccess.new({
    diversity:
      RatingCriterium.new(0.05, {
                           10 => "minority group",
                            5 => "special circumstances (medium impact)",
                            0 => "no special circumstances" }),

    skills_student_1:
      RatingCriterium.new(0.075, {
                           10 => "highly skilled",
                            5 => "good enough",
                            0 => "complete newbie" }),

    skills_student_2:
      RatingCriterium.new(0.075, {
                           10 => "highly skilled",
                            5 => "good enough",
                            0 => "complete newbie" }),

    community_involvement_student_1:
      RatingCriterium.new(0.075, {
                           10 => "active community member",
                            8 => "participated in several workshops",
                            5 => "participated in a workshop / study group",
                            3 => "participated in conferences / meetups",
                            0 => "zero community involvement" }),

    community_involvement_student_2:
      RatingCriterium.new(0.075, {
                           10 => "active community member",
                            8 => "participated in several workshops",
                            5 => "participated in a workshop / study group",
                            3 => "participated in conferences / meetups",
                            0 => "zero community involvement" }),

    ambitions:
      RatingCriterium.new(0.15, {
                           10 => "both challenging features and ambitious goals",
                            5 => "some decent issues and goals are defined",
                            0 => "goals are not set up" }),

    ability_to_work_independently:
      RatingCriterium.new(0.10, {
                           10 => "team is able to work independently and efficiently",
                            5 => "some understanding of dev processes / prior experience",
                            0 => "no evidence of prior experience or theoretical knowledge" }),

    ability_to_finish_projects_student_1:
      RatingCriterium.new(0.075, {
                           10 => "multiple accomplishments / significant accomplishment",
                            5 => "some accomplishments",
                            0 => "no evidence of any accomplishments" }),

    ability_to_finish_projects_student_2:
      RatingCriterium.new(0.075, {
                           10 => "multiple accomplishments / significant accomplishment",
                            5 => "some accomplishments",
                            0 => "no evidence of any accomplishments" }),

    motivation_for_the_program_student_1:
      RatingCriterium.new(0.05, {
                           10 => "super enthusiastic",
                            5 => "somewhat motivated",
                            0 => "no evidence of motivation" }),

    motivation_for_the_program_student_2:
      RatingCriterium.new(0.05, {
                           10 => "super enthusiastic",
                            5 => "somewhat motivated",
                            0 => "no evidence of motivation" }),

    support:
      RatingCriterium.new(0.05, {
                           10 => "super strong support: more than 3 coaches / CC",
                            5 => "good support: more than 2 coaches / 2 strong coaches",
                            0 => "minimum support: 2 coaches or even less" }),

    personal_impression:
      RatingCriterium.new(0.10, {
                           10 => "I love this team!",
                            5 => "this team is a good fit",
                            0 => "no impression (neutral)" }),
  })

  FIELDS.each do |name, rating_criterium|
    define_singleton_method "#{name}_options" do
      rating_criterium.point_options
    end

    define_method name do
      data[name] if data.present?
    end

    define_method "#{name}=" do |value|
      data[name] = value
    end
  end

  belongs_to :application
  belongs_to :user

  serialize :data

  validates :user_id, uniqueness: { scope: :application_id }

  before_validation :set_data

  scope :by, ->(user) { where(user_id: user.id) }

  # public: The weighted sum of the points that the reviewer gave.
  def points
    weighted_points = FIELDS.map do |name, rating_criterium|
      rating_criterium.weighted_points(send(name))
    end

    weighted_points.sum
  end

  private

  def set_data
    new_data = ActiveSupport::HashWithIndifferentAccess.new
    FIELDS.keys.each do |name|
      points = send(name)
      new_data = new_data.merge({ name => points })
    end

    self.data = new_data
  end
end
