class Api::V1::BoardsController < Api::V1::ApplicationController
  def index
    result = Board::Index.call(current_user: current_user)
    binding.pry
    render :ok
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end
end
