class SocialMedia < ActiveRecord::Base
  validates_presence_of :url_href, :url_image, :name
end
