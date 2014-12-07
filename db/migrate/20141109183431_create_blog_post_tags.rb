class CreateBlogPostTags < ActiveRecord::Migration
  def change
    create_table :blog_post_tags do |t|
      t.integer :blog_post_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
