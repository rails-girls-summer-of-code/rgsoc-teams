require 'spec_helper'

RSpec.describe OrderedConferences do
  render_views

  describe '#index' do
    let!(:dummy_class) { Class.new { extend OrderedConferences } }
    let!(:conference)        { FactoryGirl.create :conference, :in_current_season }
    let!(:conference_europe) { FactoryGirl.create :conference_europe, :in_current_season }
    let!(:conference_na)     { FactoryGirl.create :conference_na, :in_current_season }

    it 'returns an ordered list of conferences' do
      dummy_class.index
      expectedconf = [conference_africa, conference_europe, conference_na]
      expect(@conferences).to eq(expectedconf)
    end
  end
end
