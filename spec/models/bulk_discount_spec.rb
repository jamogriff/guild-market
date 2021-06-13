require 'rails_helper'

RSpec.describe BulkDiscount do

  before :each do
    @merchant = Merchant.first
    @discount_1 = @merchant.bulk_discounts.create!(percentage_discount: 0.20, quantity_threshold: 10)
    @discount_2 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 18)
    @discount_3 = @merchant.bulk_discounts.create!(percentage_discount: 0.30, quantity_threshold: 25)
  end

  describe 'relationships' do
    it {should belong_to :merchant }
    it {should have_many :discounted_items }
    it {should have_many(:invoice_items).through(:discounted_items) }
  end

  describe 'validations' do
    it {should validate_numericality_of(:percentage_discount).
        is_greater_than_or_equal_to(0.01).
        is_less_than_or_equal_to(1) }
    it {should validate_numericality_of(:quantity_threshold).
        only_integer.
        is_greater_than_or_equal_to(5).
        is_less_than_or_equal_to(1000) }
    it {should validate_presence_of :percentage_discount}
    it {should validate_presence_of :quantity_threshold}
    end

  describe 'class methods' do
    it 'should list bulk orders by threshold' do
      expect(@merchant.bulk_discounts.order_by_threshold.first).to eq @discount_1
      expect(@merchant.bulk_discounts.order_by_threshold.last).to eq @discount_3
    end

    it 'returns quantity thresholds' do
      expect(@merchant.bulk_discounts.thresholds).to eq [10,18,25]
    end
  end

end
