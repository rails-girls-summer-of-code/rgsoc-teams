module ApplicationsHelper
  Application::FLAGS.each do |flag|
    define_method(:"display_#{flag}?") { not session[:"hide_#{flag}"] }
    define_method(:"hide_#{flag}?")    { session[:"hide_#{flag}"] }
  end

  def rating_classes_for(rating, user)
    classes = []
    classes << "pick" if rating.pick?
    classes << 'own_rating' if rating.user == user
    classes.join(' ')
  end

  def application_classes_for(application)
    classes = [cycle(:even, :odd)]
    classes << 'selected' if application.selected?
    classes << 'volunteering_team' if application.volunteering_team?
    classes.join(' ')
  end

  def formatted_application_data_value(key, value)
    markdown_fields = %w(project_plan1 project_plan2)
    value = value.presence || 'n/a'
    formatted = case
    when markdown_fields.include?(key.to_s)
      render_markdown value
    when /project._id/ =~ key.to_s
      project = Project.find_by_id value
      link_to_if project, project.try(:name), project
    else
      auto_link simple_format(value)
    end
    content_tag :p, formatted.html_safe
  end

  def format_application_location(application)
    country = country_for_application(application).to_s
    location = location_for_application(application).to_s
    location = location.gsub(country, '').gsub(%r(^\s*/\s*), '').gsub(/[\(\)]*/, '')
    [location.strip, country.strip].select(&:present?).join('/')
  end

  def country_for_application(application)
    country = application.country
    country = 'US' if country == 'United States of America'
    country = 'UK' if country == 'United Kingdom'
    country
  end

  def location_for_application(application)
    application.city.present? ? application.city : application.team.students.map(&:location).reject(&:blank?).join(', ')
  end

  def link_to_ordered(text, type)
    link_to text, rating_applications_path(order: type)
  end

  def format_application_projects(application)
    link_to_application_project(application) || links_to_application_projects(application)
  end

  def link_to_application_project(application)
    if project = application.project
      link_txt = project.name
      link_txt += " (#{application.project_visibility})" if application.project_visibility
      link_to link_txt, project
    end
  end

  def format_application_flags(application)
    flags = Application::FLAGS.select do |flag|
      application.send(:"#{flag}?")
    end
    flags.map { |flag| flag.to_s.titleize }.join(', ')
  end

  def format_application_money(application)
    money = application.application_data.
      values_at('student0_application_money', 'student1_application_money').
      reject(&:blank?)
    safe_join(money.map{|m| number_to_currency m, precision: 0}, "\n")
  end

  private

  def links_to_application_projects(application)
    projects = Project.where id: application.application_data.values_at('project1_id')
    projects += Project.where id: application.application_data.values_at('project2_id')
    safe_join(projects.map{|p| link_to(p.name, p)}, "<br/>".html_safe)
  end
end
