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

end
