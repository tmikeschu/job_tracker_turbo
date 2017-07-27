class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Hello, #{@user.username}!"
      session[:user_id] = @user.id
      redirect_to dashboard_path
    else
      flash[:error] = @user.errors.full_messages.join(", ")
      render :new
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end

