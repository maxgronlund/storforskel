class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :body
      t.belongs_to :site
      t.belongs_to :section
      t.belongs_to :user
      
      
      t.timestamps
    end
    add_index :blogs, :site_id
    add_index :blogs, :section_id
    add_index :blogs, :user_id
    
  end
end
