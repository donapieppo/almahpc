class AuthorizedKeysController < ApplicationController
  def new
    authorize :authorized_key
    @authorized_key = current_user.authorized_keys.new
  end

  def create
    @authorized_key = current_user.authorized_keys.new
    @authorized_key.name = params[:authorized_key][:name]
    @authorized_key.description = params[:authorized_key][:description]
    authorize @authorized_key
    if @authorized_key.save
      redirect_to root_path, notice: "Authorized Key created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @authorized_key = current_user.authorized_keys.find(params[:id])
    authorize @authorized_key
    @authorized_key.destroy!
    redirect_to root_path
  end
end
