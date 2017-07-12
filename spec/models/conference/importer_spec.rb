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
      before do
        #   CSV.stub(:foreach).with(file.path, {headers: true}).and_yield([headers]).and_call_original
        # OR ???
        # allow(described_class).to receive(:call).with(file.path, {headers: true }).and_ return/yield/call???
      end

      xit 'imports the valid conferences' do
        # 6 sample conferences in test.csv, 2 invalid
        expect(Conference.count).to eq 0
        expect(subject).to change { Conference.count }.by(4)
      end

      xit 'updates an existing conference' do
        existing = FactoryGirl.create(:conference, gid: 2017001, city: "Bangalore", country: "Belgium")
        expect(subject).to change(existing, :city).from("Bangalore").to("Gent")
        expect(subject).not_to change(existing, :country)
      end

      xit 'neglects a conference without a name' do
        # gid 2017003 is invalid
        expect(subject).not_to change(Conference.find_by(gid: 2017003))
        expect(Rails.logger).to receive(:error).with(/can't be blank/).and_call_original
      end

      xit 'raises an for invalid dates' do
        # gid 2017002 has an start_date later than end_date
        expect(subject).not_to change(Conference.find_by(gid: 2017002))

        # leave this out? logger receiving the message is tested ^, and validation is tested in conference.rb
        expect(Rails.logger).to receive(:error).with(/must be later/).and_call_original
      end

      xit "will not destroy conferences" do
        # gid 2017010 is not in the .csv file
        deleted = FactoryGirl.create(:conference, gid: 2017010)
        expect(subject).not_to change {deleted}
      end

      xit 'computes the season_id' do
        expect(Conference.find_by(gid: 2017001).season.name).to eq "2017"
        expect(Conference.find_by(gid: 2018004).season.name).to eq "2018"
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
