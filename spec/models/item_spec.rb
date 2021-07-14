require 'rails_helper'

RSpec.describe Item do

  describe 'relationships' do
    it {should have_many :invoice_items}
    it {should have_many(:invoices).through(:invoice_items)}
  end

  describe 'class methods' do
    it '::not_yet_shipped' do
      shippable_items = Item.not_yet_shipped

      expect(shippable_items.size).to eq(135)
      expect(shippable_items.first.invoice_date.to_s).to eq("2012-03-27 11:54:11 UTC")
      expect(shippable_items.last.invoice_date.to_s).to eq("2012-03-06 21:54:10 UTC")
    end
  end
end
