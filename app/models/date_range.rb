class DateRange
  
  # Step 1: only in use with Conference date range.
  # Validated in Conference: presence and chronological order
  #  because the input is done there.
  
  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
  end
  
  # Accepts dates
  # Returns a string with one or more dates, with
  # the following formats:
  # 12 - 13 Jul 2017 or 30 Jul - 1 Aug 2017 or
  # 31 Dec 2017 - 5 Jan 2018 or 1 Dec 2017 - 12 Dec 2018
  def to_s
    elements = "%-d %b %Y" # 1 Jul 2017
    last_day = end_date.strftime(elements)
    return last_day if start_date == end_date
    
    same_years = start_date.year == end_date.year
    same_months = start_date.month == end_date.month
    elements = elements.chomp(' %Y') if same_years
    elements = elements.chomp(' %b') if same_months
    first_day = start_date.strftime(elements)
    first_day + ' - ' + last_day
  end

  private
  
  attr_reader :start_date, :end_date
end