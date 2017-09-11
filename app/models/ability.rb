class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    can :manage, User, id: user.id
    can :manage, Board, user_id: user.id
    can :manage, Task, board: { user_id: user.id }
  end
end
