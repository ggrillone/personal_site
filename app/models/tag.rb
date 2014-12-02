class Tag < ActiveRecord::Base
  belongs_to :admin_user
  has_many :post_tags

  validates_presence_of :admin_user_id, :name

  def count
    PostTag.where(tag_id: id).count
  end
end
