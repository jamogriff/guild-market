require 'rails_helper'

RSpec.describe 'updates item' do
  before :all do
    VCR.insert_cassette('Site_Wide/github_statistics', :record => :new_episodes)
  end

  after :all do
    VCR.eject_cassette
  end
  before :each do
    @merchant_1 = Merchant.first
    @item_1 = Item.first
  end

  it 'can update just the name of the item' do
    visit "/merchants/#{@merchant_1.id}/items/#{@item_1.id}"

    click_link 'Update Item'

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_1.id}/edit")

    fill_in 'Name', with: 'Sneakers'
    click_on 'Update'

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_1.id}")
    expect(page).to have_content('Sneakers')
  end
end
