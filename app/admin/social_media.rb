ActiveAdmin.register SocialMedia do
  permit_params :url_href, :url_image, :name
  actions :all, except: [:show]
  config.filters = false

  index do
    selectable_column

    column :id
    column :name
    column :url_href
    column :url_image
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
      f.input :url_image
    end

    f.actions
  end
end