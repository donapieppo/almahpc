class HpcMembershipPolicy < ApplicationPolicy
  def create?
    @user.hpc_group_manager?(@record.hpc_group)
  end

  def destroy?
    @user.hpc_group_manager?(@record.hpc_group)
  end
end
