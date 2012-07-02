class CreateBlogs < ActiveRecord::Migration
  def change
    create_table :blogs do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.string :image
      t.text :crop_params
      t.string :pdf_download

      t.timestamps
    end
    add_index :blogs, :user_id
  end
end
