class Board::Destroy < Trailblazer::Operation
  step :find_model!
  step Policy::Pundit(BoardPolicy, :destroy?)
  step :process!

  def find_model!(options, params:, **)
    options['model'] = Board.find_by(id: params[:id])
  end

  def process!(options)
    options['model'].destroy
  end
end
