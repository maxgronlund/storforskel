class Blog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :crop_params, :pdf_download, :title, :user_id
  validates_presence_of :title, :body
  
  has_many :comments, as: :commentable
  
  mount_uploader :pdf_download, PdfUploader
  mount_uploader :image, ImageUploader
  
  attr_accessible :image, :image_cache, :remove_image
  serialize :crop_params, Hash
  include ImageCrop 
  
  BLOG_SUBJECTS = %w[blog idea info proposal sugestion]
  
  def self.search(search)
    if search
      where('title LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  

  scope :blogs , where(:blog_subject => 'blog')
  scope :ideas , where(:blog_subject => 'idea')
  scope :infos , where(:blog_subject => 'info')
  scope :proposals , where(:blog_subject => 'proposal')
  scope :sugestions , where(:blog_subject =>'sugestion')
  
  #scope :product_selectable, where("catalogs.catalog_type_id NOT IN (?)", [CATALOG_TYPES[:sibling][:id], CATALOG_TYPES[:service][:id]])

  
end
