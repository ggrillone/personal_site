class AdminUserAudit < ActiveRecord::Base
  belongs_to :admin_user

  validates_presence_of :admin_user_id, :ip, :action, :data

  scope :create_action, -> { where("action LIKE '%create'") }
  scope :update_action, -> { where("action LIKE '%update'") }
  scope :delete_action, -> { where("action LIKE '%delete'") }
end
