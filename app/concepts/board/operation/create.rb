class Board::Create < Trailblazer::Operation
  step Model(Board, :new)
  step :assign_current_user!
  step Policy::Pundit(BoardPolicy, :create?)
  step Contract::Build(constant: Board::Contract::Create)
  step Contract::Validate()
  step Contract::Persist()

  def assign_current_user!(options)
    options['model'].user_id = options['current_user'].id
  end
end
