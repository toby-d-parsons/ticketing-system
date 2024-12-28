class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
    @roles = Role.all
  end

  def create
    @user = User.new(user_params)
    @roles = Role.all
    @role = @user.role.name
    if @user.save
      redirect_to admin_users_index_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  private
  def user_params
    params.expect(user: [ :email_address, :role_id, :password, :password_confirmation ])
  end
end
