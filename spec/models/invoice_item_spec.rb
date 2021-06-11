require 'rails_helper'

RSpec.describe InvoiceItem do

  describe 'relationships' do
    it {should belong_to :invoice}
    it {should belong_to :item}
    it {should have_many :discounted_items }
  end

  describe 'class methods' do
    describe '.total_revenue' do
      it 'returns expected total revenue of all invoice items' do

        expect(InvoiceItem.total_revenue).to eq(60481323)
      end
    end
  end
end
