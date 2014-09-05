class Project < ActiveRecord::Base
  belongs_to :team

  validates :name, presence: true

  def p_name
    name
  end

end
