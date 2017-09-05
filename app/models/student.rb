class Student < SimpleDelegator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  REQUIRED_DRAFT_FIELDS =
    [
      :name, :application_about, :application_motivation, :application_gender_identification, :application_diversity, :application_age,
      :application_coding_level, :application_community_engagement, :application_giving_back, :application_language_learning_period,
      :application_learning_history, :application_skills,
      :application_code_samples, :application_location, :application_money, :application_goals, :application_code_background
    ]

  CHARACTER_LIMIT = 2000

  CHARACTER_LIMIT_FIELDS =
    [
      :application_about, :application_code_background, :application_skills, :application_community_engagement,
      :application_learning_history, :application_goals, :application_motivation, :application_giving_back,
      :application_diversity
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
    @current_team ||= Team.joins(:roles)
      .references(:roles)
      .in_current_season
      .where('roles.user_id' => user.id, 'roles.name' => 'student')
      .first
  end

  def current_drafts
    @current_drafts ||= if current_team
      current_team.application_drafts.in_current_season
    else
      []
    end
  end

  def current_draft
    @current_draft ||= current_drafts.first
  end

end
