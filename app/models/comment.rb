class Comment < ActiveRecord::Base
  belongs_to :blog_post

  validates_presence_of :blog_post_id, :email, :display_name, :ip, :body

  scope :approved, -> { where.not(approved_at: nil) }
  scope :not_approved, -> { where(approved_at: nil) }
end
