require 'spec_helper'
require 'csv'

RSpec.describe Conference::Importer do
  include ActionDispatch::TestProcess

  describe "#call" do
    let!(:file) { fixture_file_upload("spec/fixtures/files/test.csv", 'text/csv') }
    subject { described_class.call(file) } # file is now a ActionDispatch tempfile

    it { puts file_fixture_path } # => spec/fixtures/files

    it 'works' do
      expect { subject }.not_to raise_error
      expect(CSV.foreach(file.path, { headers: true}).count).to eq 6
    end

    context 'with valid file' do

      it 'imports the valid conferences' do
        # 6 sample conferences in test.csv, 3 invalid
        expect(Conference.count).to eq 0
        expect{subject}.to change { Conference.count }.by(3)
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
        # gid 2017002 has an start_date later than end_date
        expect {subject}.not_to change{Conference.find_by(gid: 2017002)}
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
      let(:file) { fixture_file_upload("spec/fixtures/files/test.csv", 'json') }

      it 'raises an error with other mime_type' do
        allow(described_class).to receive(:call).with(file).and_raise(ArgumentError)
      end
    end
  end
end

# Content of test.csv ~ Only 2017001, 005, 006 are valid

# UID;Name;Start date;End date;City;Country;Region;Website;Notes
# 2017001;Deccan RubyConf 2017;Aug 12, 17;Aug 12, 17;Gent;Belgium;Europe;http://www.deccanrubyconf.org/;
# 2017002;JSFoo 2017;Sep 15, 17;Sep 14, 17;Bangalore;India;Asia Pacific;https://jsfoo.in/2017/;
# 2017003;;;;Delhi;India;Asia Pacific;https://in.pycon.org/;1st week of Nov (dates are to be defined)
# 2017004;GHC India 2017;17/11/2017;15/11/2017;Bangalore;India;Asia Pacific;https://ghcindia.anitaborg.org/;They have student scholarship applications. Deadline: June 30, 2017
# 2018005;PyCon Pune 2018;;;Pune;India;Asia Pacific;https://pune.pycon.org/;Dates are to be defined
# 2017006;CheesyRuby;07/07/2017;15/07/2017;Amsterdam;NL;Europe;www.example.com;Duly Noted
