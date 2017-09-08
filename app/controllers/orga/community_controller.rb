class Orga::CommunityController < Orga::BaseController
 
  def reset_user_availability
    notice = User::AvailabilitySwitcher.reset ? 'Coaches were reset with success.' : 'Coaches were not reset.'
    redirect_to orga_users_info_path, flash: { notice: notice }
  end
end