module ApplicationsHelper
  [:bonus_points, :cs_students, :remote_teams, :duplicates].each do |flag|
    define_method(:"display_#{flag}?") { session[:"display_#{flag}"] }
  end
end
