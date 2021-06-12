require 'rails_helper'
require './app/services/calendar_service.rb'

# VCR used for happy paths and webmock usee for sad path testing
RSpec.describe 'Github Statistics' do

  describe 'happy path' do
    it 'returns number of pull requests', :vcr do
      expect(GithubService.num_merged_prs).to be_instance_of Integer
    end

    it 'returns name and link to repo', :vcr do
      expect(GithubService.repo_details[:name]).to eq 'little-esty-shop'
    end

    it 'returns hash of contributors with num of commits', :vcr do
      expect(GithubService.contributors['jamogriff']).to be_instance_of Integer
    end
  end
  
  describe 'sad path' do
    it 'returns error if connection failed' do
      json_mock = File.read('./spec/api_fixtures/contributor_response.json')
      stub_request(:get, "https://api.github.com/repos/jamogriff/little-esty-shop/contributors").
      to_return(status: 403, body: json_mock, headers: {})

      expect{ GithubService.contributors }.to raise_error(ApiConnectionError)
    end
  end

end

