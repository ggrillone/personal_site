class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :admin_user_id
      t.string :body
      t.string :title
      t.string :cover_image
      t.string :summary
      t.string :live_demo_url
      t.string :live_demo_url_text
      t.string :github_source

      t.timestamps
    end
  end
end
