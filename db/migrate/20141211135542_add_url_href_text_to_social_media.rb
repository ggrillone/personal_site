class AddUrlHrefTextToSocialMedia < ActiveRecord::Migration
  def change
    add_column :social_media, :url_href_text, :text
  end
end
