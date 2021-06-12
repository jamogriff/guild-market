require './app/errors/api_connection_error.rb'

class CalendarService

  def self.next_three_holidays
    response = conn.get('/api/v2/NextPublicHolidays/US')
    validate_conn(response)[0..2]
  end

  private

  def self.conn
    # add base path here
    Faraday.new('https://date.nager.at')
    # can append a do block to assign headers in request
  end

  def self.validate_conn(response)
    if response.status != 200
      raise ApiConnectionError
    else
      JSON.parse(response.body, symbolize_names: true)
    end
  end
end
