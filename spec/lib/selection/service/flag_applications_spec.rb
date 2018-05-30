require 'selection/service/flag_applications'
require 'rails_helper'

RSpec.describe Selection::Service::FlagApplications do
  let(:valid_data) do
    {
      'student0_application_location_lat':          '30.1279442',
      'student0_application_location_lng':          '31.3300184',
      'student1_application_location_lat':          '30.0444196',
      'student1_application_location_lng':          '31.2357116',
      'student0_application_gender_identification': 'Female',
      'student1_application_gender_identification': 'Female',
      'student0_application_age':                   '22-30',
      'student1_application_age':                   '22-30',
    }
  end

  let(:roles) { build_list(:coach_role, 2) + build_list(:student_role, 2) }
  let(:team)  { create(:team, :in_current_season, roles: roles) }

  subject { described_class.new.call }

  context 'when data matches requirements' do
    let!(:application) { create(:application, :in_current_season, team: team, application_data: valid_data) }

    it 'does not flag application' do
      expect { subject }.not_to change { application.reload.flags }
    end
  end

  context 'when locations too far from each other' do
    let(:data)         { valid_data.tap { |d| d['student0_application_location_lat'] = '31' } }
    let!(:application) { create(:application, :in_current_season, team: team, application_data: data) }

    it 'flags application as remote' do
      expect { subject }
        .to change { application.reload.flags }
        .from([]).to contain_exactly('remote_team')
    end
  end

  context 'when location data missing' do
    let(:data) do
      valid_data.tap do |d|
        d['student0_application_location_lat'] = nil
        d['student0_application_location_lng'] = nil
      end
    end
    let!(:application) { create(:application, :in_current_season, team: team, application_data: data) }

    it 'does not flag application as remote' do
      expect { subject }.not_to change { application.reload.flags }
    end
  end

  context 'when not enough coaches' do
    let!(:application) { create(:application, :in_current_season, team: team, application_data: valid_data) }
    let(:roles)        { build_list(:student_role, 2) << build(:coach_role) }
    let(:team)         { create(:team, :in_current_season, roles: roles) }

    it 'flags application as less_than_two_coaches' do
      expect { subject }
        .to change { application.reload.flags }
        .from([]).to contain_exactly('less_than_two_coaches')
    end
  end

  context 'when too young team' do
    let(:data)         { valid_data.tap { |d| d['student1_application_age'] = 'under 18' } }
    let!(:application) { create(:application, :in_current_season, team: team, application_data: data) }

    it 'flags application as age_below_18' do
      expect { subject }
        .to change { application.reload.flags }
        .from([]).to contain_exactly('age_below_18')
    end
  end

  context 'when male student' do
    let(:data)         { valid_data.tap { |d| d['student0_application_gender_identification'] = 'guy' } }
    let!(:application) { create(:application, :in_current_season, team: team, application_data: data) }

    it 'flags application as male_gender' do
      expect { subject }
        .to change { application.reload.flags }
        .from([]).to contain_exactly('male_gender')
    end
  end

  context 'when multiple things wrong' do
    let!(:application) { create(:application, :in_current_season, team: team, application_data: data) }
    let(:data) do
      {
        'student0_application_location_lat':          '31.0',
        'student0_application_location_lng':          '31.',
        'student1_application_location_lat':          '30.',
        'student1_application_location_lng':          '31.',
        'student0_application_gender_identification': 'Female',
        'student1_application_gender_identification': 'Male',
        'student0_application_age':                   '22-30',
        'student1_application_age':                   '70-80',
      }
    end

    it 'flags application with multiple flags' do
      expect { subject }
        .to change { application.reload.flags }
        .from([]).to contain_exactly('remote_team', 'male_gender')
    end
  end

  context 'when wrong season' do
    let(:roles)       { build_list(:student_role, 2) }
    let(:team)        { create(:team, :last_season, roles: roles) }
    let(:application) { create(:application, season: team.season) }

    it 'does not change any flags' do
      expect { subject }.not_to change { application.reload.flags }
    end
  end
end
