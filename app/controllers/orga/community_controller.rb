class Orga::CommunityController < Orga::BaseController

  def reset_user_availability
    notice = User.reset_availability! ? 'Users were reset with success.' : 'Users were not reset.'
    redirect_to orga_users_info_path, flash: { notice: notice }
  end
end
