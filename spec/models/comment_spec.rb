require 'rails_helper'

RSpec.describe Comment, :type => :model do
  it { is_expected.to validate_presence_of :post_id }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :display_name }
  it { is_expected.to validate_presence_of :ip }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to belong_to :post }
end
