ActiveAdmin.register SocialMedia do
  permit_params :url_href, :url_image, :name, :url_image_text, :url_href_text
  actions :all, except: [:show]
  config.filters = false
  config.sort_order = 'name_asc'

  controller do
    def create
      @social_media = SocialMedia.new(permitted_params[:social_media])

      if @social_media.save
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', nil, nil)
        flash[:notice] = "Social media was successfully created."
        redirect_to admin_social_media_path
      else
        render 'new'
      end
    end

    def update
      @social_media = SocialMedia.find(params[:id])
      original_attrs = @social_media.attributes

      if @social_media.update(permitted_params[:social_media])
        new_attrs = @social_media.attributes
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', original_attrs, new_attrs)
        flash[:notice] = 'Social media was successfully updated.'
        redirect_to admin_social_media_path
      else
        render 'edit'
      end
    end

    def destroy
      @social_media = SocialMedia.find(params[:id])

      if @social_media.destroy
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', nil, nil)
        flash[:notice] = "Social media was successfully deleted."
        redirect_to admin_social_media_path
      else
        flash[:alert] = "Social media failed to delete."
        redirect_to :back
      end
    end
  end

  index do
    selectable_column

    column :id
    column :name
    column :url_image do |social_media|
      image_tag social_media.url_image, size: '50x50', alt: social_media.url_image_text
    end
    column 'Social media link' do |social_media|
      link_to social_media.url_href_text, social_media.url_href, target: '_blank'
    end
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