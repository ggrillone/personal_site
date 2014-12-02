require 'rails_helper'

RSpec.describe AdminUser, :type => :model do
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of :email }
  it { is_expected.to validate_presence_of :password }
  it { is_expected.to have_many :admin_user_audits }
  it { is_expected.to have_many :posts }
  it { is_expected.to have_many :tags }
end
