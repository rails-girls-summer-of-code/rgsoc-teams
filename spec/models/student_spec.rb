require 'spec_helper'

RSpec.describe Student do

  let(:user) { build_stubbed(:user) }

  subject { described_class.new user }

  describe 'its constructor' do
    it 'sets the user' do
      subject = described_class.new user
      expect(subject.user).to eql user
    end

    it 'sets an anonymous user' do
      subject = described_class.new
      expect(subject.user).to be_a_new User
    end
  end

  describe '#name' do
    it 'returns the user\'s name' do
      user.name = 'Foobar'
      user.github_handle = ''
      expect(subject.name).to eql 'Foobar'
    end

    it 'returns the user\'s github handle' do
      user.name = ''
      user.github_handle = 'foomeister'
      expect(subject.name).to eql 'foomeister'
    end
  end

  describe '#current_drafts' do
    it 'returns an empty list if no team can be determined' do
      expect(subject.current_drafts).to eql []
    end

    context 'with a team' do
      let(:user) { create :user }
      let(:team) { create :team }

      before do
        create :student_role, user: user, team: team
        team.application_drafts.create(season: create(:season, name: 1999))
      end

      subject { described_class.new user }

      it 'returns all drafts of the current season' do
        draft = team.application_drafts.create
        expect(subject.current_drafts).to match_array [draft]
      end
    end
  end

  describe '#current_draft' do
    it 'returns an empty list if no team can be determined' do
      expect(subject.current_draft).to be_nil
    end

    it 'returns the first draft' do
      drafts = ['first', 'second']
      allow(subject).to receive(:current_drafts).and_return(drafts)
      expect(subject.current_draft).to eq 'first'
    end
  end

end
