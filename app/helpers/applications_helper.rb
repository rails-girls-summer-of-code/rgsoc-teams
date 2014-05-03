module ApplicationsHelper
  def display_bonus_points?
    session[:display_bonus_points]
  end

  def display_super_students?
    session[:display_super_students]
  end
end
