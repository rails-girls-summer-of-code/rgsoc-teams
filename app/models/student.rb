class Student < SimpleDelegator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  attr_reader :user

  def initialize(user = User.new)
    @user = user
    super
  end

  def name
    user.name_or_handle
  end

  def application_gender_identification
    user.application_gender
  end

  def current_team
    @current_team ||= user.roles.student.first.try :team
  end

  def current_draft
    @current_draft ||= current_team.application_drafts.
      where(season_id: Season.current.id).first if current_team
  end

end
