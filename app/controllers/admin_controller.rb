class AdminController < ApplicationController
  
  
  def index
     @breadcrumbs = {"Home" => root_path}
    authorize! :read, User
  end
  
end
