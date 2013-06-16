require 'spec_helper'

describe ApplicationHelper do
  describe '.link_to_team_members' do
    before do
      @team   = create(:team)
      @member1 = create(:member, name: 'Trung Le')
      @member2 = create(:member, name: 'Hieu Le')
      @member3 = create(:member, name: 'Trang Le')
      @role1  = create(:student_role, member: @member1, team: @team)
      @role2  = create(:coach_role,   member: @member2, team: @team)
      @role3  = create(:mentor_role,  member: @member3, team: @team)
    end

    it 'should return link_to student based on role type' do
      link_to_team_members(@team).should           == "<a href=\"/users/#{@member1.id}\">Trung Le</a>, <a href=\"/users/#{@member2.id}\">Hieu Le</a>, <a href=\"/users/#{@member3.id}\">Trang Le</a>"
      link_to_team_members(@team, :student).should == "<a href=\"/users/#{@member1.id}\">Trung Le</a>"
      link_to_team_members(@team, :coach).should   == "<a href=\"/users/#{@member2.id}\">Hieu Le</a>"
      link_to_team_members(@team, :mentor).should  == "<a href=\"/users/#{@member3.id}\">Trang Le</a>"
    end

  end

  describe '.link_to_user_roles' do
    before do
      @team    = create(:team, name: '29-enim')
      @member1 = create(:member, name: 'Trung Le')
      @role2   = create(:coach_role,  member: @member1, team: @team)
      @role3   = create(:mentor_role, member: @member1, team: @team)
    end

    it 'should return link_to role based on student' do
      link_to_user_roles(@member1).should == "<a href=\"/teams/#{@team.id}\">29-enim (coach)</a>, <a href=\"/teams/#{@team.id}\">29-enim (mentor)</a>"
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