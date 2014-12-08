class BlogPostTag < ActiveRecord::Base
  belongs_to :blog_post
  belongs_to :tag

  validates_presence_of :blog_post_id, :tag_id
end
