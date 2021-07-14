require 'rails_helper'

RSpec.describe 'admin index page', type: :feature do

  before :all do
    VCR.insert_cassette('Site_Wide/github_statistics', :record => :new_episodes)
  end

  describe 'Page' do
    it 'main' do
      visit '/'

      expect(page).to have_content('Welcome to Guild Market')
    end

    it 'contains a link to each merchant dashboard page' do
      merchant = Merchant.find(1)
      visit '/'

      expect(page).to have_link('Schroeder-Jerde')
      click_link('Schroeder-Jerde')
      expect(current_path).to eq("/merchants/#{merchant.id}/dashboard")
    end
  end

  after :all do
    VCR.eject_cassette
  end

end
