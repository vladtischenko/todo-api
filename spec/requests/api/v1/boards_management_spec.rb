require 'rails_helper'

describe 'Boards management', type: :request do
  describe 'GET#index' do
    it 'Unauthorized' do
      get '/api/v1/boards'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      let(:user) { create(:user) }
      let(:auth_headers) { user.create_new_auth_token }
      let(:boards) { create_list(:board, 3, user: user) }
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

  describe 'POST#create' do
    it 'Unauthorized' do
      get '/api/v1/boards'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      let(:user) { create(:user) }
      let(:auth_headers) { user.create_new_auth_token }
      let(:board_attrs) { attributes_for(:board) }
      let(:params) do
        {
          data: {
            attributes: {
              name: board_attrs[:name]
            }
          }
        }
      end
      let(:invalid_params) do
        {
          data: {
            attributes: {
              name: ''
            }
          }
        }
      end

      it 'successfully creates' do
        expect do
          post '/api/v1/boards', params: params, headers: auth_headers
        end.to change { user.boards.count }.by(1)
        expect_status(200)
        board = user.boards.last
        expect(board.name).to eq board_attrs[:name]
        expect(user.reload.boards_count).to eq 1
        expect_json('data.id', board.id.to_s)
        expect_json('data.type', 'boards')
        expect_json('data.attributes.name', board.name)
      end

      it 'returns unprocessable_entity' do
        post '/api/v1/boards', params: invalid_params, headers: auth_headers
        expect_status(:unprocessable_entity)
        expect_json('errors.0.detail', "Name can't be blank")
      end
    end
  end


  describe 'PUT#update'
  describe 'DELETE#destroy'
end
