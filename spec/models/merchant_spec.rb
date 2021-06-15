require 'rails_helper'

RSpec.describe Merchant do
  before(:each) do
    @gary = Merchant.find(1)
    @item_1 = Item.find(1)
    @item_2 = @gary.items.create!(name: "Pants", description: "Gary does not wear it", unit_price: 6, enabled: "disabled")
  end

  # Most of these references weren't added as db level constraints
  describe 'relationships' do
    it {should have_many :items}
    it {should have_many :invoice_items}
    it {should have_many :invoices}
    it {should have_many :transactions}
    it {should have_many :customers}
    it {should have_many :bulk_discounts}
  end

  describe 'class methods' do
    describe '#top_five' do
      it 'returns the top 5 merchants by name and total revenue' do
        expect(Merchant.top_five[0].name).to eq('Terry-Moore')
        expect(Merchant.top_five[0].total_revenue).to eq(3115616)
        expect(Merchant.top_five[1].name).to eq('Marvin Group')
        expect(Merchant.top_five[1].total_revenue).to eq(3053663)
        expect(Merchant.top_five[2].name).to eq('Pacocha-Mayer')
        expect(Merchant.top_five[2].total_revenue).to eq(2977622)
        expect(Merchant.top_five[3].name).to eq('Crona LLC')
        expect(Merchant.top_five[3].total_revenue).to eq(2887879)
        expect(Merchant.top_five[4].name).to eq('Reynolds Inc')
        expect(Merchant.top_five[4].total_revenue).to eq(2849929)
      end
    end
    describe '#filter_by_enabled' do
      it 'returns all enabled merchants' do
        expect(Merchant.filter_by_enabled.count).to eq(41)
      end
    end
    describe '#filter_by_disabled' do
      it 'returns all disabled merchants' do
        Merchant.create(name: 'Big Bird', enabled: false)
        expect(Merchant.filter_by_disabled.count).to eq(1)
      end
    end
  end

  describe 'instance methods' do
    describe '#top_revenue_day' do
      it 'provides the top revenue day for a given merchant' do
        top_merchant = Merchant.find(84)
        expect(top_merchant.top_revenue_day.to_s).to eq('2012-03-26')
      end
    end
    it 'collects enabled items' do
      expect(@gary.enabled_items).to include(@item_1)
    end

    it '#disabled_items' do
      expect(@gary.disabled_items).to include(@item_2)
    end

    it '#top_five_items' do
      expect(@gary.top_five_items).to include(@item_1)
    end
  end
end
