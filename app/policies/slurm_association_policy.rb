class SlurmAssociationPolicy < ApplicationPolicy
  def create?
    @user.slurm_account_manager?(@record.slurm_account)
  end

  def update?
    @user.slurm_account_manager?(@record.slurm_account)
  end

  def destroy?
    @user.slurm_account_manager?(@record.slurm_account)
  end
end
