class Board::Update < Trailblazer::Operation
  step :find_model!
  step Policy::Pundit(BoardPolicy, :update?)
  step Contract::Build(constant: Board::Contract::Update)
  step Contract::Validate()
  step Contract::Persist()

  def find_model!(options, params:, **)
    options['model'] = Board.find_by(id: params[:id])
  end
end
