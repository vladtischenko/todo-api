require 'rails_helper'

describe 'Boards management', type: :request do
  describe 'GET#index' do
    it 'Unauthorized' do
      get '/api/v1/boards'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      let(:user) { create(:user) }
      let(:boards) { create_list(:board, 3, user: user) }
      let(:auth_headers) { user.create_new_auth_token }
      let(:foreign_boards) { create_list(:board, 2) }

      it 'returns boards' do
        boards
        foreign_boards
        get '/api/v1/boards', headers: auth_headers
        expect_status(200)
        expect_json_sizes('data', 3)
      end
    end
  end

  describe 'GET#show'
  describe 'POST#create'
  describe 'PUT#update'
  describe 'DELETE#destroy'
end
