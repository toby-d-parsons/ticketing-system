class Admin::UsersController < AdminController
  before_action :load_available_roles
  before_action :set_user, only: %i[ edit update ]

  def index
    @users = User.all.order(:id).page(params[:page]).per(10)
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
      UserMailer.registration_confirmation(@user).deliver
      redirect_to admin_users_path, notice: "User created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def resend_activation_email
    user = User.find(params[:id])
    UserMailer.registration_confirmation(user).deliver
    redirect_to admin_users_path, notice: "Activation email resent"
  end

  def edit
    puts @user.inspect
    puts params.inspect
    puts @user.persisted?
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_users_path
      puts "yes bueno"
    else
      render :edit, status: :unprocessable_entity
      puts "no bueno"
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to admin_users_path
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def load_available_roles
    @roles = Role.all
  end

  def user_params
    params.expect(user: [ :email_address, :role_id, :password, :password_confirmation ])
  end
end
