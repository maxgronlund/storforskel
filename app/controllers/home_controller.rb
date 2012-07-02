class HomeController < ApplicationController
  
  def index
    session[:go_to] = root_path
    @blogs = Blog.search(params[:search]).order("created_at desc").page(params[:page]).per(10)
  end

end
