require 'rails_helper'

RSpec.describe BulkDiscount do

  describe 'relationships' do
    it {should belong_to :merchant }
    it {should have_many :discounted_items }
    it {should have_many(:invoice_items).through(:discounted_items) }
  end

end
