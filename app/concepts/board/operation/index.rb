class Board::Index < Trailblazer::Operation
  # step Policy::Pundit( Board::Policy, :index? )
  step :process!

  def process!(options, params:)
    params[:current_user].boards
  end
end
