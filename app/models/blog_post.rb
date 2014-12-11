class BlogPost < ActiveRecord::Base
  belongs_to :admin_user
  has_many :blog_post_tags
  has_many :comments, dependent: :destroy
  has_many :tags, through: :blog_post_tags

  validates_presence_of :admin_user_id, :body, :title, :cover_image, :cover_image_alt_text, :summary,
                        :live_demo_url, :live_demo_url_text, :github_source

  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false) }
end
