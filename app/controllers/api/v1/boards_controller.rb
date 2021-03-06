class Api::V1::BoardsController < Api::V1::ApiController
  include Concerns::ControllerSorting
  include Concerns::ControllerFiltering

  def index
    items = Board::Index.call({}, 'current_user' => current_user)['models']
    items = sort_collection(items)
    items = filter_collection(items, BoardQuery)
    # include
    items = items.page(pagination_params[:number]).per(pagination_params[:size])
    json_data = BoardRepresenter.for_collection.new(items).as_json
    json_data[:meta] = total_pages(items)
    json_data[:links] = links(items)
    render json: json_data
  end

  def show
    result = Board::Show.call(params, 'current_user' => current_user)
    render json: BoardRepresenter.new(result['model']).as_json
  end

  def create
    result = Board::Create.call(extract_attributes, 'current_user' => current_user)
    if result.success?
      render json: BoardRepresenter.new(result['model']).as_json
    else
      render json: ErrorSerializer.serialize(result['contract.default'].errors), status: :unprocessable_entity
    end
  end

  def update
    result = Board::Update.call(extract_attributes.merge(id: params[:id]), 'current_user' => current_user)
    if result.success?
      render json: BoardRepresenter.new(result['model']).as_json
    else
      render json: ErrorSerializer.serialize(result['contract.default'].errors), status: :unprocessable_entity
    end
  end

  def destroy
    result = Board::Destroy.call(params, 'current_user' => current_user)
    if result.success?
      head :no_content
    else
      render json: ErrorSerializer.serialize(result['contract.default'].errors), status: :unprocessable_entity
    end
  end

  private

  def sort_list
    %w[
      name
      created_at
      updated_at
    ]
  end

  def filter_list
    %w[
      name
      created_from_date
      created_to_date
      updated_from_date
      updated_to_date
    ]
  end
end
