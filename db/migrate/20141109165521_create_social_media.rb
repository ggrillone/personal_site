class CreateSocialMedia < ActiveRecord::Migration
  def change
    create_table :social_media do |t|
      t.string :url_href
      t.string :url_image
      t.string :name

      t.timestamps
    end
  end
end
