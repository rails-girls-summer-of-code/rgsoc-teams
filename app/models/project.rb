class Project < ActiveRecord::Base

  belongs_to :submitter, class_name: 'User'

  validates :name, :submitter, presence: true

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

end
