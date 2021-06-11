require 'rails_helper'

RSpec.describe DiscountedItem do

  describe 'relationships' do
    it {should belong_to :bulk_discount }
    it {should belong_to :invoice_item }
  end

end
