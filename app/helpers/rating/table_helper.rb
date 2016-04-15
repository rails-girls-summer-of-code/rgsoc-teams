module Rating::TableHelper
  def link_to_ordered(text, type)
    link_to text, rating_applications_path(order: type)
  end
end
