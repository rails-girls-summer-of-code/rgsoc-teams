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
end
