class SocialSessionsController < ApplicationController
  
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    
    if user
      if user.id == 1
        user.role = 'super'
        user.save
      end
      cookies[:auth_token] = user.auth_token  
      session[:user_id] = user.id
      redirect_to user_path(current_user), :notice => "Welcome back "+ user.name
    else
      flash[:error] = "Invalid email or password"
      redirect_to root_path
    end
  end
  
  def destroy
    session[:user_id] = nil
    cookies[:auth_token]  = nil
    redirect_to root_url, notice: "Signed out!"
  end
  
  
protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
