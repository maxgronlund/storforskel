class CommentsController < ApplicationController
  respond_to :html, :xml, :json
  before_filter :load_commentable
  load_and_authorize_resource
  
  def index
    @comments = @commentable.comments
  end

  def new
    @comment = @commentable.comments.new
  end

  def create
    @comment = @commentable.comments.new(params[:comment])
    if @comment.save
      redirect_to @commentable, notice: "Kommentar oprettet."
    else
      render :new
    end
  end
  
  def edit
    
  end
  
  def update
    if @comment.update_attributes(params[:comment])
      flash[:notice] = "Kommentar opdateret"
    else
      flash[:error] = "Noget gik galt"
    end
    respond_with(@blog, location: session[:go_to])
  end
  
  
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to session[:go_to] || root_path
  end

private

  def load_commentable
    resource, id = request.path.split('/')[1, 2]
    @commentable = resource.singularize.classify.constantize.find(id)
  end

  # alternative option:
  # def load_commentable
  #   klass = [Article, Photo, Event].detect { |c| params["#{c.name.underscore}_id"] }
  #   @commentable = klass.find(params["#{klass.name.underscore}_id"])
  # end
end