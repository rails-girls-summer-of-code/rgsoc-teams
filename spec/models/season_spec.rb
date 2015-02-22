require 'spec_helper'

describe Season do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context 'with callbacks' do
    context 'before validation' do
      it 'sets applications_open_at to the beginning of day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.applications_open_at = date
        expect { subject.valid? }.to \
          change { subject.applications_open_at }.to \
          DateTime.parse('2015-02-22 0:00 UTC')
      end

      it 'sets applications_close_at to the end of day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.applications_close_at = date
        expect { subject.valid? }.to \
          change { subject.applications_close_at }.to \
          DateTime.parse('2015-02-22 23:59:59 GMT')
      end
    end
  end
end
