require 'rails_helper'

RSpec.describe ConferencePreference, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:team).optional }
    it { is_expected.to belong_to(:first_conference).optional }
    it { is_expected.to belong_to(:second_conference).optional }
  end

  describe 'validates terms of ticket and terms of travel' do
    let(:terms_false)              { { terms_of_ticket: false, terms_of_travel: false } }
    let(:preference_without_terms) { build(:conference_preference, **terms_false) }
    let(:preference_with_terms)    { build(:conference_preference) }

    context 'when both terms are not checked' do
      before { preference_without_terms.validate }

      it 'conference preferences is not valid' do
        expect(preference_without_terms).not_to be_valid
      end

      it 'terms of ticket raise an error' do
        expect(preference_without_terms.errors[:terms_of_ticket]).not_to be_empty
      end

      it 'terms of travel raise an error' do
        expect(preference_without_terms.errors[:terms_of_travel]).not_to be_empty
      end
    end

    context 'when terms of travel are not checked' do
      before do
        preference_without_terms.terms_of_ticket = true
        preference_without_terms.validate
      end

      it 'conference preferences is not valid' do
        expect(preference_without_terms).not_to be_valid
      end

      it 'terms of ticket raise no errors' do
        expect(preference_without_terms.errors[:terms_of_ticket]).to be_empty
      end

      it 'terms of travel raise an error' do
        expect(preference_without_terms.errors[:terms_of_travel]).not_to be_empty
      end
    end

    context 'when terms of ticket are not checked' do
      before do
        preference_without_terms.terms_of_travel = true
        preference_without_terms.validate
      end

      it 'conference preferences is not valid' do
        expect(preference_without_terms).not_to be_valid
      end

      it 'terms of ticket raise an error' do
        expect(preference_without_terms.errors[:terms_of_ticket]).not_to be_empty
      end

      it 'terms of travel raise no errors' do
        expect(preference_without_terms.errors[:terms_of_travel]).to be_empty
      end
    end

    context 'when both terms are checked' do
      it 'saves conference preferences if terms of ticket and terms of travel was checked' do
        expect(preference_with_terms).to be_valid
      end
    end
  end

  describe '.current teams' do
    let(:team) { create(:team, :in_current_season, :with_conference_preferences) }
    let(:old_team) { create(:team, :with_conference_preferences) }

    it 'returns just conference preference from current teams' do
      current_teams = ConferencePreference.current_teams
      expect(current_teams).to contain_exactly(team.conference_preference)
    end
  end

  describe '#terms_accepted?' do
    let(:conference_preference) { build(:conference_preference) }

    it 'returns true when both terms are accepted' do
      conference_preference.terms_of_ticket = true
      conference_preference.terms_of_travel = true
      expect(conference_preference).to be_terms_accepted
    end

    it 'returns false when both terms are not accepted' do
      conference_preference.terms_of_ticket = false
      conference_preference.terms_of_travel = false
      expect(conference_preference).not_to be_terms_accepted
    end

    it 'returns false when one term is not accepted' do
      conference_preference.terms_of_ticket = true
      conference_preference.terms_of_travel = false
      expect(conference_preference).not_to be_terms_accepted
    end
  end

  describe '#has_preference?' do
    let(:conference_preference) { build(:conference_preference) }

    context 'when conference preference has neither first or second choice set' do
      before do
        conference_preference.first_conference_id = nil
        conference_preference.second_conference_id = nil
      end

      it 'returns false' do
        expect(conference_preference).not_to be_has_preference
      end
    end

    context 'when just first conference preference choice is set' do
      before { conference_preference.second_conference_id = nil }

      it 'returns true' do
        expect(conference_preference).to be_has_preference
      end
    end

    context 'when just second conference preference choice is set' do
      before { conference_preference.first_conference_id = nil }

      it 'returns true' do
        expect(conference_preference).to be_has_preference
      end
    end

    context 'when both conference preference choice are set' do
      it 'returns true' do
        expect(conference_preference).to be_has_preference
      end
    end
  end
end
