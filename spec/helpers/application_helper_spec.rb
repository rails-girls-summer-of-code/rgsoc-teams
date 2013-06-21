require 'spec_helper'

describe ApplicationHelper do
  describe '.link_to_team_members' do
    before do
      @team  = create(:team)
      @user1 = create(:user, name: 'Trung Le')
      @user2 = create(:user, name: 'Hieu Le')
      @user3 = create(:user, name: 'Trang Le')
      @role1 = create(:student_role, user: @user1, team: @team)
      @role2 = create(:coach_role,   user: @user2, team: @team)
      @role3 = create(:mentor_role,  user: @user3, team: @team)
    end

    it 'should return link_to student based on role type' do
      link_to_team_members(@team).should           == "<a href=\"/users/#{@user1.id}\">Trung Le</a>, <a href=\"/users/#{@user2.id}\">Hieu Le</a>, <a href=\"/users/#{@user3.id}\">Trang Le</a>"
      link_to_team_members(@team, :student).should == "<a href=\"/users/#{@user1.id}\">Trung Le</a>"
      link_to_team_members(@team, :coach).should   == "<a href=\"/users/#{@user2.id}\">Hieu Le</a>"
      link_to_team_members(@team, :mentor).should  == "<a href=\"/users/#{@user3.id}\">Trang Le</a>"
    end

  end

  describe '.link_to_user_roles' do
    before do
      @team  = create(:team, name: '29-enim')
      @user1 = create(:user, name: 'Trung Le')
      @role2 = create(:coach_role,  user: @user1, team: @team)
      @role3 = create(:mentor_role, user: @user1, team: @team)
    end

    it 'should return link_to role based on student' do
      link_to_user_roles(@user1).should ==
        "<a href=\"/users?role=coach\">Coach</a> at <a href=\"/teams/1\">Team 29-enim (Sinatra)</a>, " +
        "<a href=\"/users?role=mentor\">Mentor</a> at <a href=\"/teams/1\">Team 29-enim (Sinatra)</a>"
    end
  end

  describe '.icon' do
    it 'should generate empty icons' do
      icon('edit').should == '<i class="icon-edit"></i>'
    end

    it 'should generate icons with text' do
      icon('edit', 'Edit').should == '<i class="icon-edit"></i> Edit'
    end
  end
end
