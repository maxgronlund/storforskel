class BlogArchiveController < ApplicationController
  respond_to :html, :xml, :json
  
  def index
    @blogs = Blog.all
    respond_with(@blogs)

  end
end
