class Tag < ActiveRecord::Base
  belongs_to :admin_user
  has_many :blog_post_tags, dependent: :destroy

  validates_presence_of :admin_user_id, :name
  validates_uniqueness_of :name

  def count
    BlogPostTag.where(tag_id: id).count
  end
end
