class SlurmAssociationsController < ApplicationController
  before_action :set_slurm_association_anche_check_permission, only: %i[edit update destroy]
  before_action :set_slurm_account, only: %i[new create]

  def new
    @slurm_association = @slurm_account.slurm_associations.new
    authorize @slurm_association
  end

  def create
    @slurm_association = @slurm_account.slurm_associations.new
    authorize @slurm_association

    if (@user = User.syncronizeDbAndLdap(params[:upn]))
      if @user.slurm_associations.where(slurm_account: @slurm_account).any?
        flash[:notice] = "Member already present in group."
      else
        @slurm_association.user = @user
        @slurm_association.manager = params[:manager]
        if @slurm_association.save
          flash[:notice] = "Member added to group."
        end
      end
    else
      flash[:error] = "Operation not possibile."
    end

    redirect_to @slurm_account
  end

  def edit
  end

  def update
    if @slurm_association.update(manager: params[:manager])
      redirect_to @slurm_association.slurm_account, notice: "User updated in group."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @slurm_association.destroy!
    redirect_to @slurm_association.slurm_account, notice: "Member removed from group", status: :see_other
  end

  private

  def set_slurm_account
    @slurm_account = SlurmAccount.find(params[:slurm_account_id])
  end

  def set_slurm_association_anche_check_permission
    @slurm_association = SlurmAssociation.find(params[:id])
    authorize @slurm_association
  end
end
