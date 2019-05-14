require 'rails_helper'

RSpec.describe Project, type: :model do
  it_behaves_like 'HasSeason'

  describe 'associations' do
    it { is_expected.to belong_to(:submitter).class_name(User) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
    it { is_expected.to have_many(:first_choice_application_drafts).class_name(ApplicationDraft) }
    it { is_expected.to have_many(:second_choice_application_drafts).class_name(ApplicationDraft) }
    it { is_expected.to have_many(:assigned_teams) }
    it { is_expected.to have_many(:maintainers) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:submitter) }
    it { is_expected.to validate_presence_of(:mentor_email) }
  end

  describe 'scopes' do
    describe '.selected' do
      subject(:selected) { described_class.selected }

      let!(:current_season) { Season.current }
      let!(:past_season)    { create(:season, :past) }

      let!(:project1) { create(:project, season: current_season) }
      let!(:project2) { create(:project, :accepted, season: current_season) }
      let!(:project3) { create(:project, :accepted, season: current_season) }
      let!(:project4) { create(:project, :accepted, season: current_season) }
      let!(:project5) { create(:project, :accepted, season: past_season) }

      before do
        create(:team, kind: 'full_time', project: project3, season: current_season)
        create(:team, kind: nil, project: project4, season: current_season)
        create(:team, kind: 'full_time', project: project5, season: past_season)
      end

      it 'returns only accepted projects with accepted teams' do
        expect(selected).to contain_exactly(project3)
      end

      context 'when passing a specific season' do
        subject(:selected) { described_class.selected(season: past_season) }

        it 'returns only accepted projects with accepted teams from that season' do
          expect(selected).to contain_exactly(project5)
        end
      end
    end
  end

  describe 'callbacks' do
    context 'sanitizing url input' do
      it 'adds a protocol scheme when there is none' do
        subject.url = "github.com/rails-girls-summer-of-code/rgspc-teams"
        expect {
          subject.valid?
        }.to change { subject.url }.to \
          "http://github.com/rails-girls-summer-of-code/rgspc-teams"
      end

      it 'leaves the url untouched if already fully qualified' do
        subject.url = "http://www.example.com"
        expect {
          subject.valid?
        }.not_to change { subject.url }
      end
    end

    context 'with support for more than one project maintainer' do
      subject(:project) { build :project }

      it 'adds the submitter to the list of maintainers' do
        expect { project.save }
          .to change { Maintainership.count }

        expect(project.reload.maintainers)
          .to match_array [project.submitter]
      end
    end
  end

  context 'as a finite state machine' do
    it 'starts as "proposed"' do
      expect(subject).to be_proposed
    end

    context 'with a proposed project' do
      subject { create :project }

      it 'can be pending' do
        expect(subject).to be_may_start_review
        expect { subject.start_review! }.to \
          change { subject.pending? }.to true
      end
    end

    context 'with a pending project' do
      subject { create :project, :pending }

      it 'can be accepted' do
        expect(subject).to be_may_accept
        expect { subject.accept! }.to \
          change { subject.accepted? }.to true
      end

      it 'can be rejected' do
        expect(subject).to be_may_reject
        expect { subject.reject! }.to \
          change { subject.rejected? }.to true
      end

      it 'locks comments upon rejection' do
        expect { subject.reject! }.to \
          change { subject.reload.comments_locked? }.to true
      end
    end
  end

  describe '#taglist' do
    it 'returns an empty string when tags are empty' do
      expect(subject.taglist).to eql ''
    end

    it 'returns a comma-separated string' do
      subject.tags = %w[rails ruby]
      expect(subject.taglist).to eql 'rails, ruby'
    end
  end

  describe '#taglist=' do
    it 'sets the tags by splitting at comma' do
      expect { subject.taglist = "foo, bar" }.
        to change { subject.tags }.to %w[foo bar]
    end

    it 'removes empty values' do
      expect { subject.taglist = "foo, , bar" }.
        to change { subject.tags }.to %w[foo bar]
    end
  end

  describe '#to_param' do
    it 'appends the name' do
      subject.id = 4711
      subject.name = 'Hello World'
      expect(subject.to_param).to eql '4711-hello-world'
    end
  end

  describe '#subscribers' do
    let(:submitter) { build_stubbed :user }

    context 'when comments are empty' do
      context 'when submitter is also the mentor' do
        subject do
          build :project, submitter: submitter, mentor_email: submitter.email.upcase, mentor_github_handle: submitter.github_handle
        end

        it 'returns a list with just the submitter' do
          expect(subject.subscribers).to match_array [submitter]
        end
      end

      context 'when submitter and mentor differs' do
        subject { build :project, submitter: submitter }

        it 'returns a list with just the submitter' do
          expect(subject.subscribers).to match_array [submitter, duck_type(:email)]
        end
      end
    end

    context 'with comments' do
      subject { create :project }

      let!(:comments) { create_list :comment, 2, commentable: subject }
      let(:commenters) { comments.map(&:user) }

      it 'returns submitter, mentor, and commenters' do
        expect(subject.subscribers).to match_array \
          [subject.submitter, subject.mentor, commenters].flatten
      end
    end
  end
end
