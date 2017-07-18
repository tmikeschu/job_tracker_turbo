class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      flash[:success] = "Hello, #{@user.username}!"
      redirect_to dashboard_path
    else
      flash[:error] = "Invalid #{@user ? "password" : "email"}"
      render :new
    end
  end
end

