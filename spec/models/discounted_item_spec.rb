require 'rails_helper'

RSpec.describe DiscountedItem do

  describe 'relationships' do
    it {should belong_to :bulk_discount }
    it {should belong_to :invoice_item }
  end

  describe 'populating discounted items based on available invoice items' do

    before :each do
      @merchant = Merchant.first
      @invoice = @merchant.invoices.first
      @bulk_discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 0.15)
      @bulk_discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 0.20)
      @bulk_discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.25)
    end

    it 'gathers all of eligible invoice items and applies correct bulk discount' do
      expect(DiscountedItem.all.empty?).to eq true

      DiscountedItem.initialize_discounts(@invoice.id, @merchant.bulk_discounts)
      correct_placement_1 = DiscountedItem.where("discounted_items.percentage_discount = 0.15")
      correct_placement_2 = DiscountedItem.where("discounted_items.percentage_discount = 0.20")
      correct_placement_3 = DiscountedItem.where("discounted_items.percentage_discount = 0.25")
      case_1 = correct_placement_1.all? { |item| item.quantity >= 5 && item.quantity < 8 }
      case_2 = correct_placement_2.all? { |item| item.quantity >= 8 && item.quantity < 10 }
      case_3 = correct_placement_3.all? { |item| item.quantity >= 10}
        
      expect(case_1).to eq true
      expect(case_2).to eq true
      expect(case_3).to eq true
    end

    # Method below is only executed from within ::initialize_discount,
    # So input needs to be pre-sorted
    it 'accounts for checking invoice items against largest discount' do
      DiscountedItem.destroy_all
      DiscountedItem.initialize_largest_discount(@invoice, @merchant.bulk_discounts.order_by_threshold)
      correct_placement_3 = DiscountedItem.where("discounted_items.percentage_discount = 0.25")
      case_3 = correct_placement_3.all? { |item| item.quantity >= 10}
      expect(case_3).to eq true
    end

    # Method is used so ::apply_discounts can apply a lower and upper bound to categorize available discounts
    it 'can create subsets of two for an array' do
      array_1 = [1,2,3,4]
      array_2 = [1,2,3,4,5]
      expect(DiscountedItem.create_subset(array_1)).to eq [[1,2],[2,3],[3,4]]
      expect(DiscountedItem.create_subset(array_2)).to eq [[1,2],[2,3],[3,4],[4,5]]
    end
  end

  describe '::total revenue' do

    before :each do
      @merchant = Merchant.first
      @invoice = @merchant.invoices.first
      @bulk_discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 0.15)
      @bulk_discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 0.20)
      @bulk_discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.25)
      # Apply discount methods done here
    end

    it 'returns total revenue of discounted items' do
      expect(DiscountedItem.total_revenue).to eq 444444
    end
  end
end
