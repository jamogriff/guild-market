require 'rails_helper'

RSpec.describe "items show page" do
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

  it "displays the item and its attributes" do
    visit "/merchants/#{@merchant_1.id}/items/#{@item_1.id}"

    expect(page).to have_content(@item_1.name)
    expect(page).to have_content(@item_1.description)
    expect(page).to have_content("$751.07")
  end

  it "displays the item and its attributes" do
    visit "/merchants/#{@merchant_1.id}/items/#{@item_1.id}"

    click_link 'Update Item'

    expect(current_path).to eq("/merchants/#{@merchant_1.id}/items/#{@item_1.id}/edit")
  end
end
