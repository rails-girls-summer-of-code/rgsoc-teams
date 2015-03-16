class Student < SimpleDelegator
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

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

  def current_drafts
    @current_drafts ||= if current_team
                         current_team.application_drafts.current
                       else
                         []
                       end
  end

  def current_draft
    @current_draft ||= current_drafts.first
  end

end
