require 'spec_helper'
require 'csv'

RSpec.describe Conference::Importer do

  describe "#call" do
    # 6 sample conferences in test.csv, 4 valid
    # valid: 2017001, 2017002, *2018*005 and 2017006 .
    # invalid: 2017003: no name, 2017004: start date later than end date

    let!(:file) { "spec/fixtures/files/test.csv" }

    subject { described_class.call(file, content_type: content_type) }

    context 'with valid file' do
      let(:content_type) { 'text/csv' }

      it 'imports the valid conferences' do
        expect{subject}.to change { Conference.count }.from(0).to(4)
      end

      it 'updates an existing conference' do
        FactoryGirl.create(:conference, gid: 2017001, city: "Bangalore", country: "Belgium")

        expect{subject}.to change{Conference.find_by(gid: 2017001).city}.from("Bangalore").to("Gent")
        expect{subject}.not_to change{Conference.find_by(gid: 2017001).country}
      end

      it 'neglects a conference without a name' do
        # gid 2017003
        expect {subject}.not_to change{Conference.find_by(gid: 2017003)}
      end

      it 'does not add a conference with invalid dates' do
        # gid 2017004 has an start_date later than end_date
        expect {subject}.not_to change{Conference.find_by(gid: 2017004)}
      end

      it "will not destroy conferences" do
        # gid 2017010 is not in the .csv file
        FactoryGirl.create(:conference, gid: 2017010)
        expect {subject}.not_to change{Conference.find_by(gid: 2017010)}
      end

      it 'assign the season_id' do
        FactoryGirl.create(:conference, gid: 2017001, season_id: nil)
        FactoryGirl.create(:conference, gid: 2018005, season_id: nil)
        s_2017 = FactoryGirl.create(:season, name: "2017")
        s_2018 = FactoryGirl.create(:season, name: "2018")

        expect{subject}.to change{Conference.find_by(gid: 2017001).season_id}.to(s_2017.id)
        expect(Conference.find_by(gid: 2018005).season_id).to eq s_2018.id
      end
    end

    context 'with non-csv file' do
      let(:content_type) { 'application/json' }

      it 'raises an error with other mime_type' do
        expect { subject }.to raise_error ArgumentError
      end
    end
  end
end
