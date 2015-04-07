require 'spec_helper'

RSpec.describe CreatesApplicationFromDraft do
  let(:application_draft) { build_stubbed :application_draft }

  subject { described_class.new application_draft }

  describe 'its constructor' do
    it 'sets the application draft' do
      subject = described_class.new application_draft
      expect(subject.application_draft).to eql application_draft
    end
  end

  describe '#save' do
    let(:application_draft) { create :application_draft, :appliable }
    let(:team)              { create :team, :applying_team }

    context 'with a draft that is not ready yet' do
      let(:application_draft) { ApplicationDraft.new }

      it 'will not create an application' do
        expect { subject.save }.not_to change { ApplicationDraft.count }
      end

      it 'returns nil' do
        expect(subject.save).to be_falsey
      end
    end

    context 'with application created' do

      shared_examples_for 'matches corresponding attribute' do |attribute|
        it "will not leave application.#{attribute} blank" do
          expect(subject.application_data[attribute]).to be_present
        end

        it "sets application.#{attribute} to its corresponding draft attribute" do
          draft_attribute = application_draft.send(attribute)
          expect(subject.application_data[attribute]).to eql draft_attribute.to_s
        end
      end

      before do
        described_class.new(application_draft).save
      end

      subject { Application.last }

      it 'pings the mentors' do
        skip
      end

      it 'sets the saison' do
        expect(subject.season).to be_present
        expect(subject.season).to eql application_draft.season
      end

      it 'adds a database reference to itself' do
        expect(subject.application_draft).to eql application_draft
      end

      context 'carrying over the user attributes' do
        described_class::STUDENT_FIELDS.each do |student_attribute|
          it_behaves_like 'matches corresponding attribute', student_attribute
        end
      end

      context 'carrying over the coaches\' statements' do
        %w(coaches_hours_per_week coaches_why_team_successful).each do |coaches_attribute|
          it_behaves_like 'matches corresponding attribute', coaches_attribute
        end
      end

      context 'carrying over the project related information' do
        %w(project_name project_url project_plan).each do |project_attribute|
          it_behaves_like 'matches corresponding attribute', project_attribute
        end
      end

      context 'carrying over the voluntary team information' do
        let(:application_draft) { build_stubbed(:application_draft, :appliable, :voluntary) }

        %w(voluntary voluntary_hours_per_week).each do |voluntary_attribute|
          it_behaves_like 'matches corresponding attribute', voluntary_attribute
        end
      end

      context 'carrying over misc information' do
        %w(heard_about_it misc_info).each do |misc_attribute|
          it_behaves_like 'matches corresponding attribute', misc_attribute
        end
      end

      context 'taking snapshots of the team state at creation time' do

        shared_examples_for 'takes a team member snapshot by role' do |members|
          it "saves the #{members}" do
            expected = subject.team.send(members).map { |u| [u.name, u.email] }
            expect(subject.team_snapshot[members.to_s.freeze]).to be_present
            expect(subject.team_snapshot[members.to_s.freeze]).to eql expected
          end
        end

        it_behaves_like 'takes a team member snapshot by role', :students
        it_behaves_like 'takes a team member snapshot by role', :coaches
        it_behaves_like 'takes a team member snapshot by role', :mentors
      end
    end
  end
end
