require 'rails_helper'

RSpec.describe 'discount show page' do

  before :each do
    @merchant = Merchant.first
    @discount_1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 18)
  end

  describe 'appearance' do
    it 'lists quantity and threshold' do
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
      exp_percentage = @discount_1.percentage_discount * 100

      expect(page).to have_content exp_percentage.round
      expect(page).to have_content @discount_1.quantity_threshold
    end

  end
end
