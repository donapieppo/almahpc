class SlurmAccountPolicy < ApplicationPolicy
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
    @user.slurm_account_manager?(@record)
  end

  def destroy?
    @user.is_cesia?
  end
end
