require 'spec_helper'

describe CommunityUsers do
  let(:student) { create(:student) }
  let(:student_looking_for_coach) { create(:student, :interested_in_coaching) }
  let(:coach) { create(:coach, :available) }
  describe '#all' do
    before do
      @params = {
          role: '',
          interest: '',
          availability: '',
          search: '',
          location: '',
          page: 1,
          sort: '',
          direction: 'asc'
        }

      @users = User.ordered(@params[:sort], @params[:direction])
                   .group('users.id')
                   .with_all_associations_joined

      @community = CommunityUsers.new(@params, @users)
    end

    context 'return filtered users' do
      describe 'with params presence' do
        it 'return user with role specified' do
          @params[:role] = student.roles.first.name

          community = @community
          expect(community.all).to match_array student
        end

        it 'return user with interested_in' do
          @params[:interest] = student_looking_for_coach.interested_in

          community = @community
          expect(community.all).to match_array student_looking_for_coach
        end

        it 'return user (coach) with availability' do
          @params[:availability] = coach.availability

          community = @community
          expect(community.all).to match_array coach
        end

        it 'return user by search' do
          @params[:search] = student.name

          community = @community
          expect(community.all).to match_array student
        end

        it 'return user by location' do
          @params[:location] = student.country

          community = @community
          expect(community.all).to match_array student
        end
      end
    end

    context 'private methods' do
      describe '.current_season_has_begun?' do
        it 'return true when current season has begun' do
          Timecop.travel Date.parse('2015-08-01')
          expect(@community.send(:current_season_has_begun?)).to be_truthy
        end

        it 'return false when current season has not begun' do
          Timecop.travel Date.parse('2016-01-12')
          expect(@community.send(:current_season_has_begun?)).to be_falsey
        end
      end

      describe '.present?' do
        it { expect(@community.send(:present?, @params[:page])).to be_truthy }
      end
    end
  end
end
