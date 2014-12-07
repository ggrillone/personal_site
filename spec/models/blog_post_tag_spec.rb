require 'rails_helper'

RSpec.describe BlogPostTag, :type => :model do
  it { is_expected.to validate_presence_of :blog_post_id }
  it { is_expected.to validate_presence_of :tag_id }
  it { is_expected.to belong_to :blog_post }
  it { is_expected.to belong_to :tag }
end
