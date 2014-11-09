require 'rails_helper'

RSpec.describe PostTag, :type => :model do
  it { is_expected.to validate_presence_of :post_id }
  it { is_expected.to validate_presence_of :tag_id }
  it { is_expected.to validate_presence_of :created_at }
  it { is_expected.to validate_presence_of :updated_at }
  it { is_expected.to belong_to :post }
  it { is_expected.to belong_to :tag }
end
