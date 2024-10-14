class UsersController < ApplicationController
  def index
    authorize :user
    @users = User.order(:surname, :name).all
  end

  def show
    @user = User.find(params[:id])
    @slurm_associations = @user.slurm_associations.includes(:slurm_account).load
    @authorized_keys = @user.authorized_keys
    authorize @user
  end

  def new
    authorize :user
    @user = User.new
  end

  def create
    authorize :user
    if (@user = User.syncronizeDbAndLdap(params[:user][:upn]))
      flash[:notice] = "User created."
    else
      flash[:error] = "Operation not possibile."
    end
    redirect_to users_path
  end

  # JSON pubblico per tutti
  def memberships_to_sync
    skip_authorization
    @users = SlurmAssociation.joins(:user).where("users.updated_at > ?", 1.day.ago).map(&:user).uniq
    respond_to do |format|
      format.json { render json: @users.map(&:upn).to_json }
    end
  end
end
