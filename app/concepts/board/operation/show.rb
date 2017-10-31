class Board::Show < Trailblazer::Operation
  step :find_model!
  step Policy::Pundit(BoardPolicy, :show?)

  def find_model!(options, params:, **)
    options['model'] = Board.find_by(id: params[:id])
  end
end
