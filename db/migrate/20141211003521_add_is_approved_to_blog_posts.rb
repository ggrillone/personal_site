class AddIsApprovedToBlogPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :is_approved, :boolean, default: :false
  end
end
