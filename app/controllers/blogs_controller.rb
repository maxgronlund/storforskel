class BlogsController < ApplicationController
  respond_to :html, :xml, :json
  load_and_authorize_resource

  def index
    @blogs = Blog.search(params[:search]).order("created_at desc").page(params[:page]).per(10)
    respond_with(@blogs)

  end

  def show
    session[:go_to] = blog_path(@blog)
    @commentable = @blog
    @comments = @commentable.comments
    @comment = Comment.new
    respond_with(@blogs)
  end

  def new
    @user = User.find(params[:user_id])
    @blog = @user.blogs.build(params[:blog])

    respond_with(@user, @blog)
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def create
    @user = User.find(params[:user_id])
    @blog = @user.blogs.create(params[:blog])
    @blog.blog_subject = session[:blog_type] || 'blog'

    if @blog.save
      flash[:notice] = "Blog post oprettet"
      if params[:blog][:image] && params[:blog][:remove_image] != '1'
        respond_with( @blog, :location => crop_blog_path( @blog))
      else
       respond_with(@blog, location: blog_path(@blog))
     end
    else
      flash[:error] = "Noget gik galt"
      respond_with(@user, @blog, :location => new_user_blog_path(@user, @blog))
    end

  end

  def update
    if @blog.update_attributes(params[:blog])
      flash[:notice] = "Blog post opdateret"
      
      if params[:blog][:image] && params[:blog][:remove_image] != '1'
        respond_with( @blog, :location => crop_blog_path( @blog))
      else
       respond_with(@blog, location: blog_path(@blog))
      end
    else
      flash[:error] = "Noget gik galt"
      respond_with(@user, @blog, :location => new_user_blog_path(@user, @blog))
    end
  end


  def destroy
    @blog = Blog.find(params[:id])
    @blog.destroy

    redirect_to blogs_path
  end
  
  def crop
    @crop_version = (params[:version] || :large_horizontal).to_sym
    @blog.get_crop_version! @crop_version
    @version_geometry_width, @version_geometry_height = ImageUploader.version_dimensions[@crop_version]
    
  end

  def crop_update
    @blog.crop_x = params[:blog]["crop_x"]
    @blog.crop_y = params[:blog]["crop_y"]
    @blog.crop_h = params[:blog]["crop_h"]
    @blog.crop_w = params[:blog]["crop_w"]
    @blog.crop_version = params[:blog]["crop_version"]
    @blog.save
    
    goto = session.delete(:go_to) || root_path
    redirect_to goto , :notice => "Well done! The picture fits just right"
  end
  
  def vote
    value = params[:type] == "up" ? 1 : 0
    @blog = Blog.find(params[:id])
    @blog.add_or_update_evaluation(:votes, value, current_user)
    redirect_to :back, notice: "Tak for din stemme"
  end
end
