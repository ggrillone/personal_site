class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.integer :admin_user_id
      t.text   :body
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
