class SocialMedia < ActiveRecord::Base
  validates_presence_of :url_href, :url_image, :name, :url_href_text,
                        :url_image_text
end
