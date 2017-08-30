require 'spec_helper'

RSpec.describe OrderedConferences do
  render_views

  describe '#index' do
    subject { dummy_class.new.index }

    let!(:dummy_class) do
      Class.new do
        include OrderedConferences
        def params; {} end
      end
    end

    let!(:conference)        { FactoryGirl.create :conference, :in_current_season }
    let!(:conference_europe) { FactoryGirl.create :conference_europe, :in_current_season }
    let!(:conference_na)     { FactoryGirl.create :conference_na, :in_current_season }

    it 'returns an ordered list of conferences' do
      expect(subject).to eq [conference, conference_europe, conference_na]
    end
  end
end
