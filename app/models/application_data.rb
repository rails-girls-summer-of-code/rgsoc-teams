# frozen_string_literal: true
class ApplicationData
  def initialize(data)
    @data = data || {}
  end

  def student0_application_gender_identification
    @data["student0_application_gender_identification"]
  end

  def student1_application_gender_identification
    @data["student1_application_gender_identification"]
  end

  def student0_application_location
    @data["student0_application_location"]
  end

  def student1_application_location
    @data["student1_application_location"]
  end

  def student0_application_motivation
    @data["student0_application_motivation"]
  end

  def student1_application_motivation
    @data["student1_application_motivation"]
  end

  def student0_application_location_lng
    @data["student0_application_location_lng"]
  end

  def student1_application_location_lng
    @data["student1_application_location_lng"]
  end

  def student0_application_location_lat
    @data["student0_application_location_lat"]
  end

  def student1_application_location_lat
    @data["student1_application_location_lat"]
  end

  def student0_application_diversity
    @data["student0_application_diversity"]
  end

  def student1_application_diversity
    @data["student1_application_diversity"]
  end

  def student0_application_money
    @data["student0_application_money"]
  end

  def student1_application_money
    @data["student1_application_money"]
  end

  def student0_application_skills
    @data["student0_application_skills"]
  end

  def student1_application_skills
    @data["student1_application_skills"]
  end

  def student0_application_minimum_money
    @data["student0_application_minimum_money"]
  end

  def student1_application_minimum_money
    @data["student1_application_minimum_money"]
  end

  def student0_application_community_engagement
    @data["student0_application_community_engagement"]
  end

  def student1_application_community_engagement
    @data["student1_application_community_engagement"]
  end

  def student0_application_motivation
    @data["student0_application_motivation"]
  end

  def student1_application_motivation
    @data["student1_application_motivation"]
  end

  def student0_application_coding_level
    @data["student0_application_coding_level"]
  end

  def student1_application_coding_level
    @data["student1_application_coding_level"]
  end

  def student0_application_giving_back
    @data["student0_application_giving_back"]
  end

  def student1_application_giving_back
    @data["student1_application_giving_back"]
  end

  def student0_application_giving_back
    @data["student0_application_giving_back"]
  end

  def student1_application_giving_back
    @data["student1_application_giving_back"]
  end

  def student0_application_goals
    @data["student0_application_goals"]
  end

  def student1_application_goals
    @data["student1_application_goals"]
  end

  def student0_application_code_background
    @data["student0_application_code_background"]
  end

  def student1_application_code_background
    @data["student1_application_code_background"]
  end

  def student0_application_about
    @data["student0_application_about"]
  end

  def student1_application_about
    @data["student1_application_about"]
  end

  def student0_application_learning_history
    @data["student0_application_learning_history"]
  end

  def student1_application_learning_history
    @data["student1_application_learning_history"]
  end

  def student0_application_language_learning_period
    @data["student0_application_language_learning_period"]
  end

  def student1_application_language_learning_period
    @data["student1_application_language_learning_period"]
  end

  def student0_application_about
    @data["student0_application_about"]
  end

  def student1_application_about
    @data["student1_application_about"]
  end

  def student0_application_language_learning_period
    @data["student0_application_language_learning_period"]
  end

  def student1_application_language_learning_period
    @data["student1_application_language_learning_period"]
  end

  def student0_application_code_samples
    @data["student0_application_code_samples"]
  end

  def student1_application_code_samples
    @data["student1_application_code_samples"]
  end

  def student0_application_age
    @data["student0_application_age"]
  end

  def student1_application_age
    @data["student1_application_age"]
  end

  def minimum_money
    @data["minimum_money"]
  end

  def location
    @data["location"]
  end

  def plan_project1
    @data["plan_project1"]
  end

  def plan_project2
    @data["plan_project2"]
  end

  def why_selected_project1
    @data["why_selected_project1"]
  end

  def why_selected_project2
    @data["why_selected_project2"]
  end

  def project1_id
    @data["project1_id"]
  end

  def project2_id
    @data["project2_id"]
  end

  def signed_off_by_project1
    @data["signed_off_by_project1"]
  end

  def signed_off_by_project2
    @data["signed_off_by_project2"]
  end

  def signed_off_at_project1
    @data["signed_off_at_project1"]
  end

  def signed_off_at_project2
    @data["signed_off_at_project2"]
  end

  def mentor_fav_project1
    @data["mentor_fav_project1"]
  end

  def mentor_fav_project2
    @data["mentor_fav_project2"]
  end

  def heard_about_it
    @data["heard_about_it"]
  end

  def misc_info
    @data["misc_info"]
  end

  def deprecated_voluntary
    @data["deprecated_voluntary"]
  end

  def working_together
    @data["working_together"]
  end

  def work_week_ids
    JSON.parse @data["work_weeks"] if @data["work_weeks"]
  end

  def deprecated_voluntary_hours_per_week
    @data["deprecated_voluntary_hours_per_week"]
  end
end
