class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "Hello, #{@user.username}!"
      redirect_to dashboard_path
    else
      flash[:error] = "Invalid #{@user ? "password" : "email"}"
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end

