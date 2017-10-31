class Board::Index < Trailblazer::Operation
  step :process!

  def process!(options)
    options['models'] = options['current_user'].boards
  end
end
