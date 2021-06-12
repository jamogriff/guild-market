require 'rails_helper'

RSpec.describe 'Bulk Discounts Index' do

  before :each do
    @merchant = Merchant.first
    @discount_1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 18)
  end

  describe 'calendar service' do
    it 'returns upcoming holidays', :vcr do
      # Thorough testing of this service lives in spec/services
      holidays = CalendarService.next_three_holidays
      visit "/merchants/#{@merchant.id}/bulk_discounts"
      expect(page).to have_content holidays.first[:name]
      expect(page).to have_content holidays.last[:name]
    end

    it 'flashes an error when no connection' do
      skip "Sad path for error handling bad API connection"
      json_mock = File.read('./spec/api_fixtures/calendar_response.json')
      stub_request(:get, "https://date.nager.at/api/v2/NextPublicHolidays/US").
       to_return(status: 403, body: json_mock, headers: {})
      visit "/merchants/#{@merchant.id}/bulk_discounts"
      expect(page).to have_content "Error: Cannot connect to external API."
    end
  end

  describe 'appearance' do
    it 'lists all of a merchant\'s bulk discounts', :vcr do
      VCR.use_cassette('Bulk_Discounts_Index/calendar_service/returns_upcoming_holidays') do
        visit "/merchants/#{@merchant.id}/bulk_discounts"
        exp_1 = @discount_1.percentage_discount * 100
        exp_2 = @discount_2.percentage_discount * 100
        expect(page).to have_content "#{exp_1}% off"
        expect(page).to have_content "#{exp_2}% off"
        expect(page).to have_content @discount_1.quantity_threshold
        click_link "discount-#{@discount_1.id}"
        expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
      end
    end
  end

end
