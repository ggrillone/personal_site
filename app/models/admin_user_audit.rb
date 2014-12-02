class AdminUserAudit < ActiveRecord::Base
  belongs_to :admin_user

  validates_presence_of :admin_user_id, :ip, :action, :data
end
