require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#user_for_comment' do
    subject { helper.user_for_comment(comment) }

    let(:user)    { create(:user, name: 'Alice') }
    let(:comment) { create(:comment, user: user) }

    before { allow(helper).to receive(:current_user) }

    it { is_expected.to eq('Alice') }

    context 'when the comment is by the current_user' do
      before { allow(helper).to receive(:current_user).and_return(user) }

      it { is_expected.to eq('You') }
    end

    context 'when the comment is by an admin' do
      let(:user)       { create(:organizer, name: 'Eva') }
      let(:with_label) { 'Eva <small><span class="label label-primary">RGSoC</span></small>' }

      it { is_expected.to eq(with_label) }
    end

    context 'when the comment is by a currently logged in admin' do
      let(:user) { create(:organizer, name: 'Eva') }

      before { allow(helper).to receive(:current_user).and_return(user) }

      it { is_expected.to eq('You') }
    end
  end

  describe '#application_disambiguation_link' do
    let(:draft) { create :application_draft }
    let(:user)  { create :user }

    subject { helper.application_disambiguation_link }

    it 'returns an "Apply now" link for an anonymous user' do
      allow(helper).to receive(:current_student).and_return(Student.new)
      allow(helper).to receive(:current_user)

      expect(subject).to match 'Apply now'
      expect(subject).to match apply_path
    end

    context 'as a guide' do
      let(:guide_role) { %w(coach mentor).sample }

      before do
        allow(helper).to receive(:current_student).and_return(Student.new user)
      end

      it 'returns a link to the drafts list' do
        create "#{guide_role}_role", user: user, team: draft.team
        allow(helper).to receive(:current_user).and_return(user)
        expect(subject).to match 'My Application'
        expect(subject).to match application_drafts_path
      end
    end
  end

  describe '#avatar_url' do
    it 'returns a default picture' do
      user = build_stubbed(:user)
      expect(avatar_url(user)).to match '/images/default_avatar.png'
    end

    context 'with a user avatar' do
      let(:user) do
        double(avatar_url: 'http://example.com/foo.png?', name_or_handle: 'RGSoC user')
      end

      it 'returns the user avatar' do
        expect(avatar_url(user)).to include user.avatar_url
      end

      it 'optionally accepts an avatar size' do
        expected = "#{user.avatar_url}&amp;s=42"
        expect(avatar_url(user, size: 42)).to include expected
      end
    end
  end

  describe '.link_to_team_members' do
    before do
      @team  = create(:team)
      @user1 = create(:user, name: 'Trung Le')
      @user2 = create(:user, name: 'Hieu Le')
      @user3 = create(:user, name: 'Trang Le')
      @role1 = create(:student_role, user: @user1, team: @team)
      @role2 = create(:coach_role,   user: @user2, team: @team)
      @role3 = create(:mentor_role,  user: @user3, team: @team)
      allow(self).to receive(:current_user).and_return(@user1)
    end

    it 'should return link_to student based on role type' do
      expect(link_to_team_members(@team)).to           eq(link_to_team_member(@user2) + link_to_team_member(@user3) + link_to_team_member(@user1))
      expect(link_to_team_members(@team, :student)).to eq(link_to_team_member(@user1))
      expect(link_to_team_members(@team, :mentor)).to  eq(link_to_team_member(@user3))

      expect(link_to_team_members(@team, :coach)).to   start_with link_to_team_member(@user2)
      expect(link_to_team_members(@team, :coach)).to   match "Not confirmed yet"
    end
  end

  describe '.link_to_team_member' do
    let(:user) { create(:user, name: 'Trung Le', avatar_url: 'http://example.com/avatar.png') }

    it 'should include a link to the member' do
      expect(link_to_team_member(user)).to include("<a href=\"/users/#{user.id}\">Trung Le</a>")
    end

    it 'should include the avatar image' do
      expect(link_to_team_member(user)).to include("<img alt=\"Trung Le\" src=\"#{user.avatar_url}&amp;s=40\" />")
    end
  end

  describe '.link_to_user_roles' do
    let(:team1)   { create(:team, name: '29-enim', project: project) }
    let(:team2)   { create(:team, name: '28-enim') }
    let(:user)    { create(:user, name: 'Trung Le') }
    let(:project) { create(:project, name: 'Sinatra') }

    before do
      create(:coach_role,  user: user, team: team1)
      create(:mentor_role, user: user, team: team2)
    end

    it 'should return link_to role based on student' do
      expect(link_to_user_roles(user)).to eq(
        "<a href=\"/community?role=coach\">Coach</a> at <a href=\"/teams/#{team1.id}\">Team 29-enim (Sinatra)</a>, " \
        "<a href=\"/community?role=mentor\">Mentor</a> at <a href=\"/teams/#{team2.id}\">Team 28-enim</a>"
      )
    end
  end

  describe '#links_to_conferences' do
    let(:conference) { build_stubbed :conference }

    context 'without location' do
      subject { links_to_conferences [conference] }

      it 'will show the dates in brackets' do
        link_text = "#{conference.name} (#{conference.date_range})"
        expect(subject).to eql [link_to(link_text, conference)]
      end

      context 'with location present' do
        let(:conference) do
          build_stubbed :conference, location: 'Melée Island, Carribean', starts_on: '2017-03-14', ends_on: '2017-03-17'
        end

        it 'will add location and date range in brackets' do
          link_text = "#{conference.name} (Melée Island, Carribean – 14 - 17 Mar 2017)"
          expect(subject).to eql [link_to(link_text, conference)]
        end
      end
    end
  end

  describe '#role_names' do
    before do
      @team  = create(:team)
      @user  = create(:user, name: 'Trung Le')
      @role1 = create(:coach_role,   user: @user, team: @team)
      @role2 = create(:mentor_role,  user: @user, team: @team)
    end

    it 'returns coach and mentor' do
      expect(role_names(@team, @user)).to eql 'Coach, Mentor'
    end
  end
end
