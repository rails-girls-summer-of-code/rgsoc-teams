class DateRange
  # Step 1: only in use with Conference date range.
  # Validation is supposed to be in input (e.g. Conference.rb), but
  # with the new Importer for adding conferences, the presence validation
  # of the dates is removed.
  
  ELEMENTS = "%-d %b %Y" # "1 juli 2017"
  
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
    return last_day if start_date == end_date
    
    format = ELEMENTS
    format = format.chomp(' %Y') if start_date.year == end_date.year
    format = format.chomp(' %b') if start_date.month == end_date.month
    first_day = start_date.strftime(format)
    first_day + ' - ' + last_day
  end
  
  private
  
  attr_reader :start_date, :end_date
  
  def last_day
    end_date&.strftime(ELEMENTS) || "TBA"
  end
end