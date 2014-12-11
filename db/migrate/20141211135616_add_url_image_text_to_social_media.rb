class AddUrlImageTextToSocialMedia < ActiveRecord::Migration
  def change
    add_column :social_media, :url_image_text, :string
  end
end
