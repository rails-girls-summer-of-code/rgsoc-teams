class Student < SimpleDelegator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  REQUIRED_DRAFT_FIELDS =
    [
      :name, :application_about, :application_motivation, :application_gender_identification,
      :application_coding_level, :application_community_engagement, :application_learning_period,
      :application_learning_history, :application_skills,
      :application_code_samples, :application_location, :banking_info, :application_minimum_money
    ]

  attr_reader :user

  def initialize(user = User.new)
    @user = user || User.new
    super
  end

  def name
    user.name_or_handle
  end

  def current_team
    @current_team ||= user.roles.student.first.try :team
  end

  def current_draft
    @current_draft ||= current_team.application_drafts.
      where(season_id: Season.current.id).first if current_team
  end

end
