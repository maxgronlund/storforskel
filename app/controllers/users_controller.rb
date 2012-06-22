class UsersController < ApplicationController
  respond_to :html, :xml, :json
  load_and_authorize_resource

  helper_method :sort_column, :sort_direction

  def index
    
    #@tags = User.tagged_with("awesome")
    
    @list_of_tage = User.tag_counts_on(:tags)
    
    #options = {} # any search/pagination conditions go here
    #@tags = User.tag_counts_on(:keywords => 'awesome')
    #klass = User
    #klass = klass.tagged_with(@keyword) if (@keyword = params[:keyword]).present?
    #@tags = klass
    #@tags = User.tagged_with("awesome")
       
       
    if current_user && (current_user.role == 'super' || current_user.role == 'admin')
      @breadcrumbs = { "Home" => root_path, "Admin" => admin_index_path }
    end
    session[:go_to] = users_path
    if mobile_device?
      @users = User.search(params[:search]).order("name asc").page(params[:page]).per(10)
    else
      #@users = User.search(params[:search]).order("name asc").tagged_with("hats").page(params[:page]).per(5)
      @users = User.search(params[:search]).order("name asc").page(params[:page]).per(5)
    end
  end

  def show
    if current_user && (current_user.role == 'super' || current_user.role == 'admin')
      @breadcrumbs = breadcrumbs
    end
    
    
    session[:go_to] = user_path(@user)
    respond_with( @user)
  end
  
  def new
    if current_user && (current_user.role == 'super' || current_user.role == 'admin')
      @breadcrumbs = breadcrumbs
    end
    @user = User.new
    @sites = get_sites
    respond_with( @user)
  end
  
  def edit
    if current_user && (current_user.role == 'super' || current_user.role == 'admin')
      @breadcrumbs = breadcrumbs
    end
    respond_with( @user)
  end

  
  def create
    @user = User.new(params[:user])
    
    @user.tag_list = "awesome, slick, hefty"      # this should be familiar
    @user.skill_list = "joking, clowning, boxing" # but you can do it for any context!
    
    
    @user.save do |success, failure|
      success.html do
        unless current_user
          # log users created by themself in 
           user = User.authenticate(@user.email, @user.password)
           cookies[:auth_token] = user.auth_token
           session[:user_id] = user.id
        end

        if params[:user][:image]
          flash[:success] = "You are signed up! Crop your image"
          redirect_to crop_user_path(@user)
        else
          if mobile_device?
            redirect_to users_url
          else
            redirect_to user_path(@user)
          end
        end
      end
      failure.html { render 'new' }
    end
    respond_with( @user)
  end
  
  def update
    
    remove_password_fields_if_blank! params[:user]
    unless current_user && current_user.admin_or_super?
      params[:user].delete :role
      params[:user].delete :site_id
    end
    @user.update_attributes(params[:user])
    
    if params[:user][:image] && params[:user][:remove_image] != '1'
      respond_with( @user, :location => crop_user_path(@user))
    else
     respond_with( @user)
    end
  end

  
  def crop
    @crop_version = (params[:version] || :large).to_sym
    @user.get_crop_version! @crop_version
    @version_geometry_width, @version_geometry_height = AvatarUploader.version_dimensions[@crop_version]
    
  end

  def crop_update
    @user.crop_x = params[:user]["crop_x"]
    @user.crop_y = params[:user]["crop_y"]
    @user.crop_h = params[:user]["crop_h"]
    @user.crop_w = params[:user]["crop_w"]
    @user.crop_version = params[:user]["crop_version"]
    @user.save
    
    goto = session.delete(:go_to) || root_path
    redirect_to goto , :notice => "Well done! The picture fits just right"
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    redirect_to users_url 
  end
  
  def tag
    
    #@users =  User.tagged_with(params[:id])
    #redirect_to root_path
  end
  
  
private

  def remove_password_fields_if_blank!(user_params)
    if user_params[:password].blank? and user_params[:password_confirmation].blank?
      user_params.delete :password
      user_params.delete :password_confirmation
    end
  end
  
 

  def breadcrumbs
    { "Home" => root_path,
      "Admin" => admin_index_path, 
    "Users" => users_path }
  end
end
