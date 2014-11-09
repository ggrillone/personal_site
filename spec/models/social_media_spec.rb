require 'rails_helper'

RSpec.describe SocialMedia, :type => :model do
  it { is_expected.to validate_presence_of :url_href }
  it { is_expected.to validate_presence_of :url_image }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :created_at }
  it { is_expected.to validate_presence_of :updated_at }
end
