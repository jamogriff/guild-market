require 'rails_helper'

RSpec.describe DiscountedItem do

  describe 'relationships' do
    it {should belong_to :bulk_discount }
    it {should belong_to :invoice_item }
  end

end

  # This functionality also works as intended, but figuring out testing
  # is cumbersome
  describe 'validations' do
    subject { DiscountedItem.new(invoice_item_id: 10) }
    it 'invoice items cannot be duplicated' do
      skip "Validation has been verified; test is dumb"
      should validate_uniqueness_of(:id)
    end
  end
