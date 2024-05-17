class HpcGroupPolicy < ApplicationPolicy
  def index?
    @user
  end

  def show?
    @user
  end

  def create?
    @user.is_cesia?
  end

  def update?
    @user.hpc_group_manager?(@record)
  end
end
