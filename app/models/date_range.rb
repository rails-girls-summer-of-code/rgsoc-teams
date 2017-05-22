class DateRange
  attr_reader :start_date, :end_date
  
  # Step 1: only in use with Conference date range.
  # Validated in Conference: presence and chronological order
  #  because the input is done there.
  
  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def compact
    last_day = @end_date.strftime("%d %b %Y")
    return last_day if @start_date == @end_date
    
    if (@start_date.month == @end_date.month) && (@start_date.year == @end_date.year)
      first_day = @start_date.strftime("%d") # return 01 - 02 Jun 2017
    elsif @start_date.year == @end_date.year
      first_day = @start_date.strftime("%d %b") # return 31 May - 1 Jun 2017
    else
      first_day = @start_date.strftime("%d %b %Y") # return both dates DD MM YYYY
    end
    first_day << ' - ' << last_day
  end
end