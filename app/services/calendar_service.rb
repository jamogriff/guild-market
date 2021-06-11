class CalendarService
  ENDPOINT = 'https://date.nager.at/api/v2/NextPublicHolidays/US'
  
  def self.connect
    @connection = Faraday.get(ENDPOINT)
  end

  def self.next_three_holidays
    if self.connect.status == 200
      response = JSON.parse(self.connect.body, symbolize_names: true)
      response[0..2]
    else
      puts "Cannot connect to Calendar service"
    end
  end
end
