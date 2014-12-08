ActiveAdmin.register SocialMedia do
  permit_params :url_href, :url_image, :name
  actions :all, except: [:show]

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
end