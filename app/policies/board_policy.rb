class BoardPolicy < ApplicationPolicy
  def check_ability
    return true if user.id == record.user_id
    raise Pundit::NotAuthorizedError
  end

  %i[show? create? update? destroy?].each { |method| alias_method method, :check_ability }
end
