class SessionsController < ApplicationController
  def create
    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def backdoor
    return redirect_to root_path if current_user
  end

  def ready
    return redirect_to root_path if current_user

    authorized_user = User.authenticate(params[:username],params[:login_password])
    if authorized_user
      session[:user_id] = authorized_user.id
      flash[:notice] = "Welcome again, you logged in as #{authorized_user.display_name}"
      redirect_to root_path
    else
      flash[:notice] = "Invalid Username or Password"
      flash[:color]= "invalid"
      render "backdoor"
    end
  end
end
