class Orga::CommunityController < Orga::BaseController
 
  def reset_user_availability
    if User::AvailabilitySwitcher.reset
      redirect_to orga_users_info_path, flash: { notice: 'Coaches were reset with success.' }
    else
      redirect_to orga_users_info_path, flash: { danger: 'Coaches were not reset.' }
    end
  end
end