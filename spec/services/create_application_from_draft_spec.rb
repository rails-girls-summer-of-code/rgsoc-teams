require 'rails_helper'

RSpec.describe CreateApplicationFromDraft, type: :service do
  describe '#call' do
    subject(:application) { service.call }

    let(:service) { described_class.new(application_draft) }

    context 'when the draft is not ready yet' do
      let(:application_draft) { ApplicationDraft.new }

      it 'does not create an application' do
        expect { application }.not_to change { Application.count }
      end

      it 'returns nil' do
        expect(application).to be_nil
      end
    end

    context 'when the draft is applicable' do
      let(:application_draft) { create :application_draft, :appliable, :with_two_projects }

      it 'creates a new application record' do
        expect { application }.to change { Application.count }.by(1)
      end

      it 'returns a valid application' do
        expect(application).to be_a Application
        expect(application).to be_valid
      end

      it 'sets the season and a reference to the draft' do
        expect(application).to have_attributes(
          season:            application_draft.season,
          application_draft: application_draft
        )
      end

      describe 'serializing all relevant draft fields' do
        subject(:data) { application.data }

        def match_draft_fields_with_data(fields)
          fields.each do |attr|
            draft_attr = application_draft.public_send(attr)
            data_attr  = application.data.public_send(attr)
            expect(data_attr).to eq draft_attr.to_s
            expect(data_attr).not_to be_blank
          end
        end

        it 'carries over all relevant student attributes (as strings)' do
          match_draft_fields_with_data described_class::STUDENT_FIELDS
        end

        it 'carries over all project attributes (as strings)' do
          match_draft_fields_with_data described_class::PROJECT_FIELDS
        end

        it 'carries over the misc information attributes (as strings)' do
          match_draft_fields_with_data %w(heard_about_it misc_info)
        end
      end

      describe 'taking a snapshot of the team at the time of applying' do
        let(:subject) { applciation.team_snapshot }

        shared_examples_for :member_shapshot_by_role do |members|
          it 'saves the members and does not leave any blank' do
            expected = application.team.public_send(members).map { |u| [u.name, u.email] }
            expect(application.team_snapshot[members.to_s.freeze]).not_to be_blank
            expect(application.team_snapshot[members.to_s.freeze]).to eql expected
          end
        end

        include_examples :member_shapshot_by_role, :students
        include_examples :member_shapshot_by_role, :coaches
        include_examples :member_shapshot_by_role, :mentors
      end
    end
  end
end
