module SessionHelpers
  def stub_login_for(user)
    allow_any_instance_of(ApplicationController)
      .to receive(:current_user).and_return(user)
  end
end

