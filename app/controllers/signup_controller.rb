class SignupController < ApplicationController
  before_action :signed_in?
  allow_unauthenticated_access
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.role_id = Role.find_by(name: "User").id
    if @user.save!
      UserMailer.registration_confirmation(@user).deliver
      flash[:success] = "Please confirm your email address to continue."
      redirect_to root_path
    else
      flash[:error] = "Error: Something went wrong."
      redirect_to signup_path, status: :unprocessable_entity
    end
  end

  def confirm_email
    user = User.find_by_confirm_token(params[:id])
    if user
      user.email_activate
      redirect_to root_url
      flash[:success] = "Your email has been confirmed. Please sign in to continue."
    else
      redirect_to root_url
      flash[:error] = "Sorry. User does not exist"
    end
  end

  private
  def signed_in?
    redirect_to root_path if authenticated?
  end

  def user_params
    params.expect(user: [ :email_address, :first_name, :last_name, :password, :password_digest ])
  end
end
