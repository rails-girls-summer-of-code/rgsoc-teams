require 'spec_helper'
require 'csv'

RSpec.describe Conference::Importer do
  
  describe "#call" do
    it { puts file_fixture_path } # => spec/fixtures/files

    # let!(:file) { ?? }
    context 'with valid file' do
      subject { described_class.call(file) }

      xit 'works' do
        expect(subject).not_to raise_error(ArgumentError, /.csv/)
      end
    end
  end
end
