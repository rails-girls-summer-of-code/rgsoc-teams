module ConferenceAttendancesHelper

  def show_attendance(attendance)
    label_class = case attendance
                  when true
                    'label-success'
                  when false
                    'label-warning'
                end
    text_label = case attendance
                 when true
                   "I will attend this conference"
                 when false
                   "I will not attend this conference"
                end
    content_tag :span, text_label, class: "label #{label_class}"
  end
end
