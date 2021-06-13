require 'rails_helper'

RSpec.describe BulkDiscount do

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
        is_greater_than_or_equal_to(1).
        is_less_than_or_equal_to(1000) }
    it {should validate_presence_of :percentage_discount}
    it {should validate_presence_of :quantity_threshold}
    end

end
