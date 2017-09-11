class Board::Policy
  attr_reader :user, :board

  def initialize(user, board)
    @user = user
    @board = board
  end

  def index?
    true
  end
end
