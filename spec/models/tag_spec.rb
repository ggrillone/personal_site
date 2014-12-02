require 'rails_helper'

RSpec.describe Tag, :type => :model do
  tag = Fabricate(:tag)
  post_tag = Fabricate(:post_tag, tag_id: tag.id)
  post_tag2 = Fabricate(:post_tag, tag_id: tag.id)
  it { is_expected.to validate_presence_of :admin_user_id }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to respond_to :count }
  it { is_expected.to belong_to :admin_user }
  it { is_expected.to have_many :post_tags }

  it 'is expected to return the total number of tags' do
    expect(tag.count).to be(2)
  end
end
