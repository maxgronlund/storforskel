class SugestionsController < ApplicationController
  
  def index
    @sugestions = Blog.sugestions
    session[:blog_type] = 'sugestion'
    
  end

  def show
    @blogs = Blog.find(params[:id])
    session[:go_to] = blog_path(@blog)
    respond_with(@blogs)
  end
end
