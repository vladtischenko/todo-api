class BoardPolicy < ApplicationPolicy
  def create?
    return true if user.id == record.user_id
    raise Pundit::NotAuthorizedError
  end
end
