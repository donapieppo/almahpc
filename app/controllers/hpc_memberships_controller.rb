class HpcMembershipsController < ApplicationController
  before_action :set_hpc_group

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
    redirect_to @hpc_group
  end

  private

  def set_hpc_group
    @hpc_group = HpcGroup.find(params[:hpc_group_id])
  end
end
