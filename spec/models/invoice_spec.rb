require 'rails_helper'

RSpec.describe Invoice do

  describe 'relationships' do
    it {should belong_to :customer}
    it {should have_many :invoice_items}
    it {should have_many :transactions}
    it {should have_many(:items).through(:invoice_items)}
    it {should have_many(:merchants).through(:items)}
  end

  # Not really legacy functionality, but I'm isolating the scope of the before hook
  describe 'legacy functionality' do

    before(:each) do
      @merchant = Merchant.create!(name: 'Sally Handmade')
      @merchant_2 = Merchant.create!(name: 'Billy Mandmade')
      @item =  @merchant.items.create!(name: 'Qui Essie', description: 'Lorem ipsim', unit_price: 75107)
      @item_2 =  @merchant.items.create!(name: 'Essie', description: 'Lorem ipsim', unit_price: 75107)
      @item_3 = @merchant_2.items.create!(name: 'Glowfish Markdown', description: 'Lorem ipsim', unit_price: 55542)
      @customer = Customer.create!(first_name: 'Joey', last_name: 'Ondricka') 
      @invoice = Invoice.create!(customer_id: @customer.id, status: 'completed')
      @invoice_2 = Invoice.create!(customer_id: @customer.id, status: 'completed')
      InvoiceItem.create!(item_id: @item.id, invoice_id: @invoice.id, quantity: 539, unit_price: 13635, status: 1)
      InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice.id, quantity: 539, unit_price: 13635, status: 1)
      InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice.id, quantity: 539, unit_price: 13635, status: 1)
    end

    describe '#filter_by_unshipped_order_by_age' do
      it 'returns all invoices with unshipped items sorted by creation date' do
        expect(Invoice.filter_by_unshipped_order_by_age.count("distinct invoices.id")).to eq(45)
        expect(Invoice.filter_by_unshipped_order_by_age.first.id).to eq(10)
      end
    end

    describe 'instance methods' do
      it 'returns set of invoice items with quantities between two numbers' do
        invoice = Invoice.find(29)
        # invoice only has 2 invoice items with quantities between 9 and 11
        expect(invoice.quantities_between([9,11]).count).to eq 2
      end

      it 'returns set of invoices larger than or equal to a number' do
        invoice = Invoice.find(29)
        expect(invoice.quantities_more_than(10).count).to eq 1
      end

      # Test pulls instance from test db to test against
      it 'has array of available status options' do
        single_invoice = Invoice.last
        expect(single_invoice.statuses).to eq ['in progress', 'completed', 'cancelled']
      end

      it 'calculates total potential revenue' do
        single_invoice = Invoice.last
        total_revenue = single_invoice.invoice_items.total_revenue # utilizes class method from InvoiceItems
        expect(single_invoice.revenue).to eq total_revenue
      end
    end
  end

  describe 'new functionality' do
    before :each do
      DiscountedItem.destroy_all
      @merchant = Merchant.first
      @invoice = Invoice.find(29)
      item =  @merchant.items.create!(name: 'Qui Essie', description: 'Lorem ipsim', unit_price: 75107)
      InvoiceItem.create!(item_id: item.id, invoice_id: @invoice.id, quantity: 8, unit_price: 13635, status: 1)
      bulk_discount_1 = @merchant.bulk_discounts.create!(quantity_threshold: 5, percentage_discount: 0.15)
      bulk_discount_2 = @merchant.bulk_discounts.create!(quantity_threshold: 8, percentage_discount: 0.20)
      bulk_discount_3 = @merchant.bulk_discounts.create!(quantity_threshold: 10, percentage_discount: 0.25)
      ChargeMaster.apply_discounts(@invoice.id, @merchant.bulk_discounts)
    end

    it 'calculates discounted revenue' do
      expect(@invoice.discounted_revenue).to eq 834141.9
    end

    it 'calculates remaining revenue not subject to discounts' do
      expect(@invoice.remaining_revenue).to eq 312246
    end

    it 'calculates total revenue accounting for discounts' do
      expect(@invoice.revenue_with_discounts).to eq 834141.9 + 312246
    end

    it 'collects invoice items that are full price' do
      expect(@invoice.full_price_items.length).to eq 5
    end

    it 'collects invoice items that are discounte' do
      expect(@invoice.discounted_items.length).to eq 4
    end

  end
end
