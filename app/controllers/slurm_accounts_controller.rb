class SlurmAccountsController < ApplicationController
  before_action :set_slurm_account_and_check_permission, only: %i[show edit update]

  def index
    authorize :slurm_account
    @slurm_accounts = SlurmAccount.order(:name).all
  end

  def show
  end

  def new
    authorize :slurm_account
    @slurm_account = SlurmAccount.new
  end

  def create
    authorize :slurm_account
    @slurm_account = SlurmAccount.new(slurm_account_params)

    if @slurm_account.save
      redirect_to @slurm_account, notice: "Slurm Account was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @slurm_account.update(slurm_account_params)
      redirect_to @slurm_account, notice: "Slurm Account was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @slurm_account.slurm_associations.any?
      flash[:alert] = "Please selete members before group"
    else
      @slurm_account.destroy!
      flash[:notice] = "Slurm account was successfully destroyed."
    end
    redirect_to slurm_accounts_url, status: :see_other
  end

  private

  def set_slurm_account_and_check_permission
    @slurm_account = SlurmAccount.find(params[:id])
    authorize @slurm_account
  end

  def slurm_account_params
    params.require(:slurm_account).permit(:name, :slug, :description)
  end
end
