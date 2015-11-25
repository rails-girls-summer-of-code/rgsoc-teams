class Project < ActiveRecord::Base
  validates :name, presence: true

  include AASM

  aasm do
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
