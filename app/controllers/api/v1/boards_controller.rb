class Api::V1::BoardsController < Api::V1::ApiController
  def index
    result = Board::Index.call(current_user: current_user)
    render json: BoardRepresenter.for_collection.new(result['models']).as_json
  end

  def show
  end

  def create
    result = Board::Create.call(extract_attributes, "current_user" => current_user)
    if result.success?
      render json: BoardRepresenter.new(result['model']).as_json
    else
      render json: ErrorSerializer.serialize(result['contract.default'].errors), status: :unprocessable_entity
    end
  end

  def update
  end

  def destroy
  end
end
