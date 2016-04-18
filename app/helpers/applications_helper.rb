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
    markdown_fields = %w(project_plan)
    value = value.presence || 'n/a'
    formatted = if markdown_fields.include? key.to_s
                  render_markdown value
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

  def format_application_project(application)
    project = "#{application.project_name}"
    project = "#{application.project_name} (#{application.project_visibility})" if application.project_visibility
    project
  end
  
  def format_application_flags(application)
    flags = Application::FLAGS.select do |flag|
      application.send(:"#{flag}?")
    end
    flags.map { |flag| flag.to_s.titleize }.join(', ')
  end
end
