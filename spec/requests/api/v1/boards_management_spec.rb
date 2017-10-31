require 'rails_helper'

describe 'Boards management', type: :request do
  let(:user) { create(:user) }
  let(:auth_headers) { user.create_new_auth_token }
  let(:boards) { create_list(:board, 3, user: user) }
  let(:foreign_boards) { create_list(:board, 2) }
  let(:board) { create(:board, user: user) }
  let(:foreign_board) { create(:board) }
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

  describe 'GET#index' do
    it 'Unauthorized' do
      get '/api/v1/boards'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      it 'returns boards' do
        boards
        foreign_boards
        get '/api/v1/boards', headers: auth_headers
        expect_status(200)
        expect_json_sizes('data', 3)
        boards.each_with_index do |board, index|
          expect_json("data.#{index}.id", board.id.to_s)
          expect_json("data.#{index}.type", 'boards')
          expect_json("data.#{index}.attributes.name", board.name)
        end
      end

      describe 'sort' do
        let(:board_1) { boards.first }
        let(:board_2) { boards.second }
        let(:board_3) { boards.third }

        describe 'name' do
          before do
            board_1.update(name: 'C')
            board_2.update(name: 'A')
            board_3.update(name: 'B')
          end

          it 'asc' do
            get '/api/v1/boards?sort=name', headers: auth_headers
            expect_status(200)
            expect_json_sizes('data', 3)
            expect_json('data.0.id', board_2.id)
            expect_json('data.1.id', board_3.id)
            expect_json('data.2.id', board_1.id)
          end

          it 'desc' do
            get '/api/v1/boards?sort=-name', headers: auth_headers
            expect_status(200)
            expect_json_sizes('data', 3)
            expect_json('data.0.id', board_1.id)
            expect_json('data.1.id', board_3.id)
            expect_json('data.2.id', board_2.id)
          end
        end

        describe 'created_at' do
          it 'asc'
          it 'desc'
        end

        describe 'updated_at' do
          it 'asc'
          it 'desc'
        end
      end

      describe 'filter' do
        describe 'name'
        describe 'created_from_date'
        describe 'created_to_date'
        describe 'updated_from_date'
        describe 'updated_to_date'
      end

      describe 'include' do
        describe 'user'
        describe 'tasks'
      end

      describe 'pagination' do
        it do
          boards
          get '/api/v1/boards?page[number]=1&page[size]=2', headers: auth_headers
          expect_status(200)
          expect_json_sizes('data', 2)
          expect_json_types('links', :array_of_objects)
          expect_json_types('meta.total_pages', :integer)
          expect_json('meta.total_pages', 2)
          expect_json_types('meta.total_items', :integer)
          expect_json('meta.total_items', 3)
          expect_json_types('links', :array_of_objects)
        end

        it do
          boards
          get '/api/v1/boards?page[number]=1&page[size]=5', headers: auth_headers
          expect_status(200)
          expect_json_sizes('data', 3)
          expect_json_types('links', :array_of_objects)
          expect_json_types('meta.total_pages', :integer)
          expect_json('meta.total_pages', 1)
          expect_json_types('meta.total_items', :integer)
          expect_json('meta.total_items', 3)
          expect_json_types('links', :array_of_objects)
        end

        it do
          boards
          get '/api/v1/boards?page[size]=1&page[number]=2', headers: auth_headers
          expect_status(200)
          expect_json_sizes('data', 1)
          expect_json_types('links', :array_of_objects)
          expect_json('links.self', 'http://www.example.com/api/v1/boards?page[size]=1&page[number]=2')
          expect_json('links.first', 'http://www.example.com/api/v1/boards?page[size]=1&page[number]=1')
          expect_json('links.last', 'http://www.example.com/api/v1/boards?page[size]=1&page[number]=3')
          expect_json('links.prev', 'http://www.example.com/api/v1/boards?page[size]=1&page[number]=1')
          expect_json('links.next', 'http://www.example.com/api/v1/boards?page[size]=1&page[number]=3')
        end
      end
    end
  end

  describe 'GET#show' do
    it 'Unauthorized' do
      get '/api/v1/boards/1'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      it 'returns successfully' do
        get "/api/v1/boards/#{board.id}", headers: auth_headers
        expect_status(200)
        expect_json('data.id', board.id.to_s)
        expect_json('data.type', 'boards')
        expect_json('data.attributes.name', board.name)
      end

      it 'returns with access_denied' do
        get "/api/v1/boards/#{foreign_board.id}", headers: auth_headers
        expect_status(:forbidden)
      end
    end
  end

  describe 'POST#create' do
    it 'Unauthorized' do
      post '/api/v1/boards'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
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
        expect_json('errors.0.detail', 'Name is too short (minimum is 2 characters)')
        expect_json('errors.1.detail', "Name can't be blank")
      end
    end
  end

  describe 'PUT#update' do
    it 'Unauthorized' do
      put '/api/v1/boards/1'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      it 'updates successfully' do
        put "/api/v1/boards/#{board.id}", params: params, headers: auth_headers
        expect_status(200)
        board.reload
        expect(board.name).to eq board_attrs[:name]
        expect_json('data.id', board.id.to_s)
        expect_json('data.type', 'boards')
        expect_json('data.attributes.name', board.name)
      end

      it 'returns with unprocessable_entity' do
        put "/api/v1/boards/#{board.id}", params: invalid_params, headers: auth_headers
        expect_status(:unprocessable_entity)
        expect_json('errors.0.detail', 'Name is too short (minimum is 2 characters)')
        expect_json('errors.1.detail', "Name can't be blank")
      end

      it 'returns with access_denied' do
        put "/api/v1/boards/#{foreign_board.id}", headers: auth_headers
        expect_status(:forbidden)
      end
    end
  end

  describe 'DELETE#destroy' do
    it 'Unauthorized' do
      delete '/api/v1/boards/1'
      expect_status(:unauthorized)
    end

    describe 'Authorized' do
      it 'deletes successfully' do
        board
        expect do
          delete "/api/v1/boards/#{board.id}", headers: auth_headers
        end.to change { Board.count }.by(-1)
        expect_status(:no_content)
      end

      it 'returns with access_denied' do
        delete "/api/v1/boards/#{foreign_board.id}", headers: auth_headers
        expect_status(:forbidden)
      end
    end
  end
end
