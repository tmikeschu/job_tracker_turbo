class HomeController < ApplicationController
  before_action :check_login, only: [:show]
  skip_before_action :require_login, only: [:show]

  def show
  end

  private

  def check_login
    redirect_to dashboard_path if current_user
  end
end

