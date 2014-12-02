require 'rails_helper'

RSpec.describe AdminUserAudit, :type => :model do
  it { is_expected.to validate_presence_of :admin_user_id }
  it { is_expected.to validate_presence_of :ip }
  it { is_expected.to validate_presence_of :action }
  it { is_expected.to validate_presence_of :data }
  it { is_expected.to belong_to :admin_user }
end
