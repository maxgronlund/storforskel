class Blog < ActiveRecord::Base
  belongs_to :user
  attr_accessible :body, :crop_params, :image, :pdf_download, :title
end
