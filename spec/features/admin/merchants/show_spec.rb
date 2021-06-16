require 'rails_helper'

RSpec.describe 'merchants show page', type: :feature do
  before :all do
    VCR.insert_cassette('Site_Wide/github_statistics', :record => :new_episodes)
  end

  after :all do
    VCR.eject_cassette
  end
  describe 'page appearance' do
    it 'has the merchants name' do
      visit '/admin/merchants/1'

      expect(page).to have_content('Schroeder-Jerde')
    end
  end

  describe 'page functionality' do
    it 'has a link that allows you to update the merchant' do
      visit '/admin/merchants/1'

      expect(page).to have_link('Edit')

      click_link 'Edit'

      expect(current_path).to eq('/admin/merchants/1/edit')
    end
  end
end
