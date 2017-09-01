module UsersHelper

  def show_availability(availability)
    availability ? 'I am available for this season!' : 'I am not available for this season.'
  end
end