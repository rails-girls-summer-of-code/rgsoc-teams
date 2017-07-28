require 'spec_helper'

describe ConferencePreferenceInfo, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to have_many(:conference_preferences) }

  describe '#with_preferences_build' do
   let(:conference_preference_info) { FactoryGirl.create(:conference_preference_info) }
    it 'should build a conference_preferences' do
      expect(conference_preference_info.with_preferences_build).to eq conference_preference_info.conference_preferences
    end
  end

  describe "#accepted_conditions?" do
    let(:conference_preference_info) { FactoryGirl.create(:conference_preference_info) }
    let(:cp_info_with_options_selected) { FactoryGirl.create(:conference_preference_info, :with_preferences) }

    it 'should not return an error when there are not conferences selected' do
      expect(conference_preference_info.accepted_conditions?).to be_falsey
    end

    it 'should return an error when there are conferences selected but terms are not accepted' do
      cp_info_with_options_selected.accepted_conditions?
      expect(cp_info_with_options_selected.errors[:team].first).to eql "you must accept terms and conditions."
    end
  end 
end