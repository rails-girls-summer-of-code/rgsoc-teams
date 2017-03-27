require 'spec_helper'

xdescribe Selection::Table do
  describe 'attributes', :wip do
    let(:applications) { FactoryGirl.build_list :application, 3 }
    # let(:options)      { { order: :average_points, hide_flags: [] } }

    subject { described_class.new(applications: applications) }

    # it 'has options' do
    #   expect(table.options).to eq options
    # end

    it 'has rows' do
      expect(subject.rows.size).to eq applications.count
      expect(subject.rows).to all be_a Selection::Row
    end
  end

  describe 'rows (applications)' do
    let(:users) { create_list :user, 3 }
    let(:user_names) { users.map(&:name) }
    let!(:remote_team_application) { create :application, flags: [:remote_team] }
    let!(:other_applications) { create_list :application, 3 }
    let(:table) { Rating::Table.new user_names, Application.all, options }

    subject(:applications) { table.rows.map{|r| r.application} }

    context 'with filtering' do
      context 'when hide_flags given' do
        let(:options) { { order: :average_points, hide_flags: ['remote_team'] } }

        it 'excludes rows / applications flagged with hidden flags' do
          expect(applications).to match_array other_applications
        end
      end
      context 'when not hide_flags given' do
        let(:options) { { order: :average_points } }

        it 'returns all applications' do
          all_applications = other_applications << remote_team_application
          expect(applications).to match_array all_applications
        end
      end
    end
    context 'with sorting and filtering' do
      context 'when order: :id' do
        let!(:new_application) { create :application }
        let(:options) { { order: :id, hide_flags: ['remote_team'] } }

        it 'returns filtered applications ordered by id :desc' do
          all_applications = other_applications << new_application
          expect(applications).to eq all_applications
        end
      end
      context 'when order: :average_points' do
        let(:options) { { order: :average_points, hide_flags: ['remote_team'] } }
        let!(:high_rated_application) { create :application }
        let!(:average_rated_application) { create :application }
        before do
          allow(high_rated_application).to receive(:average_points) { 10.0 }
          allow(average_rated_application).to receive(:average_points) { 5.0 }
        end

        it 'returns filtered applications highest rated first' do
          first_two = [average_rated_application, high_rated_application]
          expect(applications.first(2)).to eq first_two
        end
      end
    end
  end
end
