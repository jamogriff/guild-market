require 'rails_helper'
require './app/services/calendar_service.rb'

RSpec.describe 'Calendar Info' do

  describe 'happy path' do
    it 'returns next three holidays', :vcr do
      next_holidays = CalendarService.next_three_holidays
      expect(next_holidays).to be_instance_of Array
      expect(next_holidays.length).to eq 3
    end
  end

  describe 'sad path' do
    it 'fails to connect to an API and serves an error' do
      json_mock = File.read('./spec/api_fixtures/calendar_response.json')
      stub_request(:get, "https://date.nager.at/api/v2/NextPublicHolidays/US").
       to_return(status: 403, body: json_mock, headers: {})
      expect { CalendarService.next_three_holidays}.to raise_error(ApiConnectionError)
    end
  end

end
