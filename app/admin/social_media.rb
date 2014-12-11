ActiveAdmin.register SocialMedia do
  permit_params :url_href, :url_image, :name, :url_image_text, :url_href_text
  actions :all, except: [:show]
  config.filters = false

  index do
    selectable_column

    column :id
    column :name
    column :url_image do |social_media|
      image_tag social_media.url_image, size: '50x50', alt: social_media.url_image_text
    end
    column :url_href
    column :url_href_text
    column :url_image_text
    column 'URL image path' do |social_media|
      social_media.url_image
    end
    column :created_at do |social_media|
      social_media.created_at.strftime("%B, %e %Y %H:%M")
    end
    column :updated_at do |social_media|
      social_media.updated_at.strftime("%B, %e %Y %H:%M")
    end

    actions
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Social media details' do
      f.input :name
      f.input :url_href
      f.input :url_href_text
      f.input :url_image
      f.input :url_image_text
    end

    f.actions
  end
end