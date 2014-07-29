require 'spec_helper'

describe Application do
  subject { FactoryGirl.build_stubbed(:application) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:application_data) }

  its(:average_skill_level) { should be_present }
  its(:total_picks) { should be_present }

  it { should respond_to(:sponsor_pick?) }

  describe 'scopes' do
    describe '.hidden' do
      it 'retruns only hidden applications' do
        expect(Application.hidden.where_values).to eq(
          ["applications.hidden IS NOT NULL and applications.hidden = 't'"]
        )
      end
    end

    describe '.visible' do
      it 'retruns only visible applications' do
        expect(Application.visible.where_values).to eq(
          ["applications.hidden IS NULL or applications.hidden = 'f'"]
        )
      end
    end
  end

  describe 'flags' do
    flags = Application::FLAGS

    flags.each do |flag|
      it { should respond_to("#{flag}?") }
      it { should respond_to("#{flag}=") }
    end

    it 'adds the flag if the value is > 0' do
      flag = flags.sample.to_sym
      expect(subject.flags).not_to include(flag)

      subject.send("#{flag}=", '1')
      expect(subject.flags).to include(flag)
    end

    it 'removes the flag if the value is 0' do
      flag = flags.sample.to_sym
      subject.flags = [flag]

      expect(subject.flags).to include(flag)
      subject.send("#{flag}=", '0')
      expect(subject.flags).not_to include(flag)
    end
  end

  describe 'proxy methods' do
    proxy_methods = %w(student_name location minimum_money)

    proxy_methods.each do |key|
      its(key) { should be_present }
      its(key) { should eq(subject.application_data[key]) }
    end
  end

  describe 'rating defaults' do
    its(:rating_defaults) { should be_present }

    default_methods = %w(women_priority skill_level practice_time project_time support)

    default_methods.each do |key|
      its("estimated_#{key}") { should be_present }
    end

    describe '.estimated_support' do
      it 'returns the a estimated value depending on coach-hours' do
        hours = {
          5 => 8,
          3 => 5,
          1 => 1
        }
        hours.each do |key, value|
          subject.stub(:application_data).and_return('hours_per_coach' => key.to_s)
          expect(subject.estimated_support).to eq(value)
        end
      end
    end
  end

  describe 'sponsor pick' do
    application = FactoryGirl.create(:application)
    it 'does not have a sponsor' do
      expect(application.sponsor_pick?).to eql false
    end
  end
end
