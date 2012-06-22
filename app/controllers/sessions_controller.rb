class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token  
      end
      session[:user_id] = user.id
      redirect_to user_path(current_user), :notice => "Welcome back "+ user.name
    else
      #flash.now.alert = "Invalid email or password"
      flash[:error] = "Invalid email or password"
      render "new"
    end
  end
  
  
  def destroy
    mesage = 'Bye bye '+ current_user.name + '! hope to see you back soon'
    cookies.delete(:auth_token)
    redirect_to root_url, :notice => mesage
  end
  
end


