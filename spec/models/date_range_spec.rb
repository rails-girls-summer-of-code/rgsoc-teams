require 'spec_helper'

RSpec.describe DateRange do

  describe '#dates' do
      let(:conference) { FactoryGirl.build_stubbed(:conference)}
    
    it 'creates a date range for calling Models' do
      expect(conference.dates).to be_an_instance_of DateRange
    end
  end
  
  describe '#compact' do
    let (:conference)  { FactoryGirl.build_stubbed(:conference) }
    subject { described_class.new(Date.parse('2015-12-30'), Date.parse('2015-12-30')) }

    it 'returns a formatted dates string' do
      expect(conference.dates.respond_to? :compact).to be true
    end

    context 'depending on date range' do
      it 'returns one day range' do
        expect(subject.compact).to eq subject.end_date.to_date.strftime('%d %b %Y')
      end
      
      context 'multiple dates in same month' do
        subject { described_class.new(Date.parse('2015-12-30'), Date.parse('2015-12-31')) }
        
        it 'returns compact days' do
          expect(subject.compact).to eq ('30 - 31 Dec 2015')
        end
      end
      
      context 'multiple dates in different months' do
        subject { described_class.new(Date.parse('2015-11-30'), Date.parse('2015-12-01')) }
      
        it 'returns day-month and the year' do
          expect(subject.compact).to eq ('30 Nov - 01 Dec 2015' )
        end
      end
      
      context 'multiple dates around New Year' do
        subject { described_class.new(Date.parse('2015-12-31'), Date.parse('2016-01-01')) }
        
        it 'returns full dates' do
          expect(subject.compact).to eq ('31 Dec 2015 - 01 Jan 2016')
        end
      end
    end
  end
end
