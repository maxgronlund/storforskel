class AddTypeToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :blog_subject, :string
  end
end
