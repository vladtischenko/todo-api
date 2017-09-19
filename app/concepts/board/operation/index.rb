class Board::Index < Trailblazer::Operation
  step :process!

  def process!(options, params:)
    options['models'] = params[:current_user].boards
  end
end
