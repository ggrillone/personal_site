require 'rails_helper'

RSpec.describe BlogPost, :type => :model do
  it { is_expected.to validate_presence_of :admin_user_id }
  it { is_expected.to validate_presence_of :body }
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :cover_image }
  it { is_expected.to validate_presence_of :cover_image_alt_text }
  it { is_expected.to validate_presence_of :summary }
  it { is_expected.to validate_presence_of :live_demo_url }
  it { is_expected.to validate_presence_of :live_demo_url_text }
  it { is_expected.to validate_presence_of :github_source }
  it { is_expected.to belong_to :admin_user }
  it { is_expected.to have_many :blog_post_tags }
  it { is_expected.to have_many(:comments).dependent(:destroy) }
  it { is_expected.to have_many(:tags).through(:blog_post_tags) }
end
