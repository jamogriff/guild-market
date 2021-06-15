require 'rails_helper'

RSpec.describe InvoiceItem do

  describe 'relationships' do
    it {should belong_to :invoice}
    it {should belong_to :item}
    it {should have_many :discounted_items }
  end

  describe 'class methods' do
    it 'returns expected total revenue of all invoice items' do
      expect(InvoiceItem.total_revenue).to eq(60481323)
    end
  end

  describe 'instance methods' do
    
    before :each do
      DiscountedItem.destroy_all
      merchant = Merchant.first
      invoice = Invoice.find(29)
      @invoice_item = invoice.invoice_items.first
      item =  merchant.items.create!(name: 'Qui Essie', description: 'Lorem ipsim', unit_price: 75107)
      InvoiceItem.create!(item_id: item.id, invoice_id: invoice.id, quantity: 8, unit_price: 13635, status: 1)
      bulk_discount_1 = merchant.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 0.15)
      @bulk_discount_2 = merchant.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 0.20)
      bulk_discount_3 = merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.25)
      ChargeMaster.apply_discounts(invoice.id, merchant.bulk_discounts)
    end

    it 'finds associated bulk discount' do
      expect(@invoice_item.discount.percentage_discount).to eq @bulk_discount_2.percentage_discount
      expect(@invoice_item.discount.quantity_threshold).to eq @bulk_discount_2.quantity_threshold
    end

    it 'checks whether invoice item is full price' do
      expect(@invoice_item.full_priced?).to eq false
    end

  end
end
