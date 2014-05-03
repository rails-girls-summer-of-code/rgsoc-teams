module ApplicationsHelper
  def display_bonus_points?
    session[:display_bonus_points]
  end

  def display_cs_students?
    session[:display_cs_students]
  end
end
