require 'spec_helper'

describe ConferencePreference do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:first_conference) }
  it { is_expected.to belong_to(:second_conference) }

  describe 'validates terms of ticket and terms of travel' do
    let(:preference_without_terms) { build(:conference_preference) }
    let(:preference_with_terms) { build(:conference_preference, :with_terms_checked)}

    context 'when both terms are not checked' do
      it 'do not save conference preferences' do
        expect(preference_without_terms).not_to be_valid
      end
    end

    context 'when terms of travel are not checked' do
      before { preference_without_terms.terms_of_ticket = true}

      it 'do not save conference preferences' do
        expect(preference_without_terms).not_to be_valid
      end
    end

    context 'when terms of ticket are not checked' do
      before { preference_without_terms.terms_of_travel = true}

      it 'do not save conference preferences' do
        expect(preference_without_terms).not_to be_valid
      end
    end

    context 'when both terms are checked' do
      it 'saves conference preferences if terms of ticket and terms of travel was checked' do
        expect(preference_with_terms).to be_valid
      end
    end
  end

  describe '.current teams' do
    let(:team) { FactoryGirl.create(:team, :in_current_season, :with_preferences) }
    let(:old_team) { FactoryGirl.create(:team, :with_preferences) }

    it 'returns just conference preference from current teams' do
      current_teams = ConferencePreference.current_teams
      expect(current_teams).to contain_exactly(team.conference_preference)
    end
  end

  describe '#terms accepted?' do
    let(:conference_preference_with_terms) { FactoryGirl.build(:conference_preference, :with_terms_checked) }
    let(:conference_preference_without_terms) { FactoryGirl.build(:conference_preference) }

    context 'when conference preference terms are accepted' do
      it 'returns true' do
        expect(conference_preference_with_terms.terms_accepted?).to eql true
      end
    end

    context 'when conference preference terms are not accepted' do
      it 'returns false' do
        expect(conference_preference_without_terms.terms_accepted?).to eql false
      end
    end
  end


  describe '#has_preference?' do
    let(:conference_preference) { FactoryGirl.build(:conference_preference, :with_terms_checked)}

    context 'when conference preference has neither first or second choice set' do
      before { conference_preference.first_conference_id = nil, conference_preference.second_conference_id = nil }

      it 'returns false' do
        expect(conference_preference.has_preference?).to eql false
      end
    end

    context 'when just first conference preference choice is set' do
      before { conference_preference.second_conference_id = nil }

      it 'returns true' do
        expect(conference_preference.has_preference?).to eql true
      end
    end

    context 'when just second conference preference choice is set' do
      before { conference_preference.first_conference_id = nil }

      it 'returns true' do
        expect(conference_preference.has_preference?).to eql true
      end
    end

    context 'when both conference preference choice are set' do
      it 'returns true' do
        expect(conference_preference.has_preference?).to eql true
      end
    end
  end
end
