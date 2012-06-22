class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :body
      t.belongs_to :user
      t.string :image
      t.text :crop_params
      t.string :pdf_download

      t.timestamps
    end
    add_index :blogs, :user_id
  end
end
