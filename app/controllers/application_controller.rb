class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  before_filter :set_locale
  
private 
  def current_user
      #@current_user = User.find(session[:user_id]) if session[:user_id]
      @current_user ||= User.find_by_auth_token( cookies[:auth_token]) if cookies[:auth_token]
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    if Rails.env.development?
      redirect_to 'http://localhost:3000/422.html'
    else
      redirect_to 'http://rails-sandbox.com/422.html'
    end
  end
  
  # mobile support
  before_filter :prepare_for_mobile

  private

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?

  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device?
  end
  

  def set_locale
    I18n.locale = params[:locale] if params[:locale].present?
    I18n.locale = 'da'
    # current_user.locale
    # request.subdomain
    # request.env["HTTP_ACCEPT_LANGUAGE"]
    # request.remote_ip
  end

  def default_url_options(options = {})
    {locale: I18n.locale}
  end
  
  
end
