class AddCoverImageAltTextToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :cover_image_alt_text, :string
  end
end
