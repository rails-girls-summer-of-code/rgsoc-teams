module ConferencePreferencesHelper
  def preference_option(conference_preference)
    label_content = case conference_preference.option
                  when 1
                    'first choice'
                  when 2
                    'second choice'
                  end
    content_tag :span, "#{label_content}", class: "label label-primary"
  end
end
