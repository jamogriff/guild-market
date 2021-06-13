require 'rails_helper'

RSpec.describe 'discount edit page' do

  before :each do
    @merchant = Merchant.first
    @discount_1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
  end

  describe 'happy path' do
    it 'holds onto existing attributes' do
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
      expect(page).to have_css "input[value='10']"
      expect(page).to have_css "input[value='0.2']"
    end

    it 'can edit a new bulk discount' do
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
      fill_in "bulk_discount_percentage_discount", with: 0.5
      fill_in "bulk_discount_quantity_threshold", with: 20
      click_button 'Update Bulk discount'
      expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}"
      expect(page).to have_content "50%"
      expect(page).to have_content "20 or more of one item"
    end
  end

  describe 'sad path' do
    it 'rejects 0' do
      @merchant = Merchant.first
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
      fill_in "bulk_discount_percentage_discount", with: 0
      fill_in "bulk_discount_quantity_threshold", with: 0
      click_button 'Update Bulk discount'
      within "div#alert" do
        expect(page).to have_content "Whoops! Percentage discount must be greater than or equal to 0.01, Quantity threshold must be greater than or equal to 5"
      end
    end

    it 'rejects percentages larger than 100' do
      @merchant = Merchant.first
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
      fill_in "bulk_discount_percentage_discount", with: 1.1
      fill_in "bulk_discount_quantity_threshold", with: 20
      click_button 'Update Bulk discount'
      within "div#alert" do
        expect(page).to have_content "Whoops! Percentage discount must be less than or equal to 1"
      end
    end

    it 'only accepts numbers' do
      @merchant = Merchant.first
      visit "/merchants/#{@merchant.id}/bulk_discounts/#{@discount_1.id}/edit"
      fill_in "bulk_discount_percentage_discount", with: 'abc'
      fill_in "bulk_discount_quantity_threshold", with: 'carrot'
      click_button 'Update Bulk discount'
      within "div#alert" do
        expect(page).to have_content "Whoops! Percentage discount is not a number, Quantity threshold is not a number"
      end
    end
  end
end

