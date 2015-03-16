require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with associations' do
    it { is_expected.to belong_to(:updater).class_name('User') }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }

    context 'with more than one application' do
      let(:team) { create :team }
      let!(:draft) { team.application_drafts.create }

      def build_draft
        team.application_drafts.build
      end

      it 'allows the creation of a second application draft' do
        expect { build_draft.save }.to \
          change { team.application_drafts.count }.by(1)
      end

      context 'with an existing draft' do
        before { build_draft.save }

        let!(:third_draft) { build_draft }

        it 'prohibits the creation of a third application draft' do
          expect { third_draft.save }.not_to change { team.application_drafts.count }
          expect(third_draft.errors[:base]).to eql ['Only two applications may be lodged']
        end

        it 'allows drafts in different seasons' do
          third_draft.season = create(:season, name: 2000)
          expect { third_draft.save }.to change { team.application_drafts.count }.by(1)
        end
      end
    end
  end

  context 'with callbacks' do
    it 'sets the current season if left blank' do
      expect { subject.valid? }.to \
        change { subject.season }.from(nil).to(Season.current)
    end
  end

  describe '#role_for' do
    let(:user) { create :user }
    let(:team) { create :team }

    subject { described_class.new team: team }

    shared_examples_for 'checks for role' do |role|
      it "returns '#{role.titleize}'" do
        create "#{role}_role", user: user, team: team
        expect(subject.role_for(user)).to eql role.titleize
      end
    end

    it_behaves_like 'checks for role', 'student'
    it_behaves_like 'checks for role', 'coach'
    it_behaves_like 'checks for role', 'mentor'
  end

end
