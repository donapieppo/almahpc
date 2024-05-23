class HpcGroupsController < ApplicationController
  before_action :set_hpc_group_and_check_permission, only: %i[show edit update]

  def index
    authorize :hpc_group
    @hpc_groups = HpcGroup.order(:name).all
  end

  def show
  end

  def new
    authorize :hpc_group
    @hpc_group = HpcGroup.new
  end

  def create
    authorize :hpc_group
    @hpc_group = Project.new(hpc_group_params)

    if @hpc_group.save
      redirect_to @hpc_group, notice: "HPC group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @hpc_group.update(hpc_group_params)
      redirect_to @hpc_group, notice: "HPC group was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @hpc_group.hpc_memberships.any?
      flash[:alert] = "Please selete members before group"
    else
      @hpc_group.destroy!
      flash[:notice] = "Group was successfully destroyed."
    end
    redirect_to hpc_groups_url, status: :see_other
  end

  private

  def set_hpc_group_and_check_permission
    @hpc_group = HpcGroup.find(params[:id])
    authorize @hpc_group
  end

  def hpc_group_params
    params.require(:hpc_group).permit(:name, :slug, :description)
  end
end
