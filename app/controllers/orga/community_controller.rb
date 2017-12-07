class Orga::CommunityController < Orga::BaseController

  def reset_user_availability
    notice = User.reset_availability! ? 'Coach availability was reset successfully.' : 'Coach availability was not reset.'
    redirect_to orga_users_info_path, flash: { notice: notice }
  end
end
