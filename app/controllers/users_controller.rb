class UsersController < ApplicationController
  def index
    authorize :user
    @users = User.order(:surname, :name).all
  end

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def new
    authorize :user
    @user = User.new
  end

  def create
    authorize :user
    if (@user = User.syncronize(params[:user][:upn]))
      if !@user.ldap_create
        flash[:error] = "Operation not possibile"
      end
    end
    redirect_to users_path
  end

  def me
    if (@user = current_user)
      authorize @user
      render action: :show
    else
      skip_authorization
      redirect_to root_path
    end
  end

  def myedit
    @user = current_user
    authorize @user
    render action: :myedit
  end

  def update
    @user = current_user
    authorize @user
    if @user.update(authorized_keys: params[:user][:authorized_keys])
      redirect_to me_users_path, notice: "I tuoi dati sono stati registrati."
    else
      render action: :edit, status: :unprocessable_entity
    end
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
