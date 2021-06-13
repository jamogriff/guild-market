require 'rails_helper'

RSpec.describe 'new discount form' do
  describe 'happy path' do
    it 'can create a new bulk discount' do
      VCR.use_cassette('Bulk_Discounts_Index/calendar_service/returns_upcoming_holidays') do
        @merchant = Merchant.first
        visit "/merchants/#{@merchant.id}/bulk_discounts/new"
        fill_in "bulk_discount_percentage_discount", with: 0.05
        fill_in "bulk_discount_quantity_threshold", with: 20
        click_button 'Create Bulk discount'
        expect(current_path).to eq "/merchants/#{@merchant.id}/bulk_discounts"
        expect(page).to have_content "50%"
        expect(page).to have_content "20 or more items"
      end
    end
  end

  describe 'sad path' do
    it 'rejects 0' do
      VCR.use_cassette('Bulk_Discounts_Index/calendar_service/returns_upcoming_holidays') do
        @merchant = Merchant.first
        visit "/merchants/#{@merchant.id}/bulk_discounts/new"
        fill_in "bulk_discount_percentage_discount", with: 0
        fill_in "bulk_discount_quantity_threshold", with: 0
        click_button 'Create Bulk discount'
        within "div#alert" do
          expect(page).to have_content "Whoops! Percentage discount must be greater than or equal to 0.01, Quantity threshold must be greater than or equal to 5"
        end
      end
    end

    it 'rejects percentages larger than 100' do
      VCR.use_cassette('Bulk_Discounts_Index/calendar_service/returns_upcoming_holidays') do
        @merchant = Merchant.first
        visit "/merchants/#{@merchant.id}/bulk_discounts/new"
        fill_in "bulk_discount_percentage_discount", with: 1.1
        fill_in "bulk_discount_quantity_threshold", with: 20
        click_button 'Create Bulk discount'
        within "div#alert" do
          expect(page).to have_content "Whoops! Percentage discount must be less than or equal to 1"
        end
      end
    end

    it 'only accepts numbers' do
      VCR.use_cassette('Bulk_Discounts_Index/calendar_service/returns_upcoming_holidays') do
        @merchant = Merchant.first
        visit "/merchants/#{@merchant.id}/bulk_discounts/new"
        fill_in "bulk_discount_percentage_discount", with: 'abc'
        fill_in "bulk_discount_quantity_threshold", with: 'carrot'
        click_button 'Create Bulk discount'
        within "div#alert" do
          expect(page).to have_content "Whoops! Percentage discount is not a number, Quantity threshold is not a number"
        end
      end
    end
  end
end
