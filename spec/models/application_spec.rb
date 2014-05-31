require 'spec_helper'

describe Application do
  subject { FactoryGirl.create(:application) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:application_data) }

  its(:average_skill_level) { should be_present }
  its(:total_picks) { should be_present }

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

  describe "flags" do
    flags = %w(mentor_pick cs_student remote_team volunteering_team in_team duplicate selected)

    flags.each do |flag|
      it { should respond_to("#{flag}?") }
      it { should respond_to("#{flag}=") }
    end

    it 'adds the flag if the value is > 0' do
      flag = flags.sample
      expect(subject.flags).not_to include(flag)

      subject.send("#{flag}=", '1')
      expect(subject.flags).to include(flag)
    end

    it 'removes the flag if the value is 0' do
      flag = flags.sample
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
  end
end
