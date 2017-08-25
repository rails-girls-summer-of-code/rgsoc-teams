require 'spec_helper'

describe ConferencePreference do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:first_conference) }
  it { is_expected.to belong_to(:second_conference) }

  describe 'validates terms of ticket and terms of travel' do
    let(:preference_without_terms) { FactoryGirl.build(:conference_preference) }
    let(:preference_with_terms) { FactoryGirl.build(:conference_preference, :with_terms_checked)}

    it 'do not save conference preferences if both terms are not checked' do
      expect(preference_without_terms.terms_of_ticket).to eql false
      expect(preference_without_terms.terms_of_travel).to eql false
      expect(preference_without_terms).not_to be_valid
      expect(preference_without_terms.errors[:terms_of_ticket]).not_to be_empty
      expect(preference_without_terms.errors[:terms_of_travel]).not_to be_empty
    end

    it 'do not save conference preferences if just terms of ticket are not checked' do
      preference_without_terms.terms_of_ticket = true
      expect(preference_without_terms.terms_of_ticket).to eql true
      expect(preference_without_terms.terms_of_travel).to eql false
      expect(preference_without_terms).not_to be_valid
      expect(preference_without_terms.errors[:terms_of_ticket]).to be_empty
      expect(preference_without_terms.errors[:terms_of_travel]).not_to be_empty
    end

    it 'do not save conference preferences if just terms of travel are not checked' do
      preference_without_terms.terms_of_travel = true
      expect(preference_without_terms.terms_of_ticket).to eql false
      expect(preference_without_terms.terms_of_travel).to eql true
      expect(preference_without_terms).not_to be_valid
      expect(preference_without_terms.errors[:terms_of_ticket]).not_to be_empty
      expect(preference_without_terms.errors[:terms_of_travel]).to be_empty
    end

    it 'saves conference preferences if terms of ticket and terms of travel was checked' do
      expect(preference_with_terms.terms_of_ticket).to eql true
      expect(preference_with_terms.terms_of_travel).to eql true
      expect(preference_with_terms).to be_valid
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

    it 'returns true in case the conference preference terms are accepted' do
      expect(conference_preference_with_terms.terms_accepted?).to eql true
    end

    it 'returns false in case the team has not accepted the terms' do
      expect(conference_preference_without_terms.terms_accepted?).to eql false
    end
  end


  describe '#has_preference?' do
    let(:conference_preference) { FactoryGirl.build(:conference_preference, :with_terms_checked)}

    it 'returns true if first and second conference choice is set' do
      expect(conference_preference.has_preference?).to eql true
    end

    it 'returns true if only the first conference choice is set' do
      conference_preference.second_conference_id = nil
      expect(conference_preference.has_preference?).to eql true
    end

    it 'returns true if only the second conference choice is set' do
      conference_preference.first_conference_id = nil
      expect(conference_preference.has_preference?).to eql true
    end

    it 'returns false if a conference preference has not first or second choice set' do
      conference_preference.first_conference_id = nil
      conference_preference.second_conference_id = nil
      expect(conference_preference.has_preference?).to eql false
    end
  end
end
