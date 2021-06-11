require 'rails_helper'

RSpec.describe 'bulk discounts indes page' do

  before :each do
    @merchant = Merchant.first
    @discount_1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 18)
  end

  describe 'appearance' do
    it 'lists all of a merchant\'s bulk discounts' do
      visit "/merchants/#{@merchant.id}/bulk_discounts"
      exp_1 = @discount_1.percentage_discount * 100
      exp_2 = @discount_2.percentage_discount * 100
save_and_open_page
      expect(page).to have_content "#{exp_1}% off"
      expect(page).to have_content "#{exp_2}% off"
      expect(page).to have_content @discount_1.quantity_threshold
      click_link "discount-#{@discount_1.id}"
      expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
    end

    it 'has list of next upcoming holidays in the US' do
    end
  end

end
