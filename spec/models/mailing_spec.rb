require 'rails_helper'

RSpec.describe Mailing, type: :model do
  describe 'associations and attributes' do
    it { is_expected.to have_many(:submissions).dependent(:destroy) }

    it { is_expected.to define_enum_for(:group).with_values(everyone: 0, selected_teams: 1, unselected_teams: 2) }
    it { is_expected.to serialize(:to) }
    it { is_expected.to delegate_method(:emails).to(:recipients) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:to) }
    it { is_expected.to validate_presence_of(:subject) }
  end

  describe '#sent?' do
    subject(:mailing) do
      build(:mailing,
            from: Mailing::FROM,
            subject: 'Greetings from an island',
            to: 'coaches',
            cc: 'cc@email.com',
            bcc: 'bcc@email.com')
    end

    it 'returns false before submitting' do
      expect(mailing.subject).to eq 'Greetings from an island'
      expect(subject.sent?).to eq false
    end

    it 'returns true after submitting' do
      mailing.save!
      mailing.submit
      expect(mailing.sent_at).not_to be_nil
      expect(mailing.submissions).not_to be_nil
      expect(mailing.sent?).to eq true
    end
  end

  describe '#submit' do
    subject(:mailing) { build(:mailing, from: Mailing::FROM, to: 'coaches', cc: 'cc@email.com', bcc: 'bcc@email.com') }

    it 'delivers emails to all recipients' do
      expect(mailing.recipients.emails).to eq(["cc@email.com", "bcc@email.com"])
      expect(mailing.recipients.to).to eq "coaches"
    end

    it 'has a default sender' do
      expect(mailing.from).not_to be_nil
    end
  end

  describe '#recipient?' do
    subject(:mailing) { build(:mailing) }

    let!(:student) { create(:student) }

    it 'returns false for a an empty recipients list' do
      mailing.to = nil
      expect(mailing.recipient? student).to be_falsey
    end

    it 'returns true if user has appropriate role' do
      mailing.to = %w(students)
      expect(mailing.recipient? student).to be_truthy
    end
  end
end
