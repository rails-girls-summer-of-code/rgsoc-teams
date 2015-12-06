class Project < ActiveRecord::Base

  include HasSeason

  belongs_to :submitter, class_name: 'User'
  has_many :comments, dependent: :destroy

  validates :name, :submitter, presence: true

  scope :current, -> do
    where(season: Season.transition? ? Season.succ : Season.current)
  end

  include AASM

  aasm whiny_transitions: false do
    state :proposed, initial: true
    state :accepted
    state :rejected

    event :accept do
      transitions from: :proposed, to: :accepted
    end

    event :reject do
      transitions from: :proposed, to: :rejected
    end
  end

  def taglist
    tags.join(', ')
  end

  def taglist=(taglist)
    self.tags = taglist.split(',').map(&:strip).reject(&:blank?)
  end
end
