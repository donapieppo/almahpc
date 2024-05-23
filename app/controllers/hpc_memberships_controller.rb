class HpcMembershipsController < ApplicationController
  before_action :set_hpc_membership_anche_check_permission, only: %i[edit update destroy]
  before_action :set_hpc_group, only: %i[new create]

  def new
    @hpc_membership = @hpc_group.hpc_memberships.new
    authorize @hpc_membership
  end

  def create
    @hpc_membership = @hpc_group.hpc_memberships.new
    authorize @hpc_membership

    @user = User.syncronize(params[:upn])
    @hpc_membership.user = @user
    @hpc_membership.manager = params[:manager]
    @hpc_membership.save

    redirect_to @hpc_group, notice: "Member added to group."
  end

  def edit
  end

  def update
    if @hpc_membership.update(manager: params[:manager])
      redirect_to @hpc_membership.hpc_group, notice: "User updated in group."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hpc_membership.destroy!
    redirect_to @hpc_membership.hpc_group, notice: "Member removed from group", status: :see_other
  end

  private

  def set_hpc_group
    @hpc_group = HpcGroup.find(params[:hpc_group_id])
  end

  def set_hpc_membership_anche_check_permission
    @hpc_membership = HpcMembership.find(params[:id])
    authorize @hpc_membership
  end
end
