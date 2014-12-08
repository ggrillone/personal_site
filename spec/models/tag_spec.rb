require 'rails_helper'

RSpec.describe Tag, :type => :model do
  tag = Fabricate(:tag)
  blog_post_tag = Fabricate(:blog_post_tag, tag_id: tag.id)
  blog_post_tag2 = Fabricate(:blog_post_tag, tag_id: tag.id)
  it { is_expected.to validate_presence_of :admin_user_id }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_uniqueness_of :name }
  it { is_expected.to respond_to :count }
  it { is_expected.to belong_to :admin_user }
  it { is_expected.to have_many(:blog_post_tags).dependent(:destroy) }

  it 'is expected to return the total number of tags' do
    expect(tag.count).to be(2)
  end
end
