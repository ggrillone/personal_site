require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it { is_expected.to validate_presence_of :admin_user_id }
  it { is_expected.to validate_presence_of :created_at }
  it { is_expected.to validate_presence_of :updated_at }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to respond_to :count }
end
