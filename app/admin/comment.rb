ActiveAdmin.register Comment do
  belongs_to :blog_post
  permit_params :blog_post_id, :email, :display_name, :ip, :body
  actions :all, except: [:new, :create]
  includes :blog_post
  filter :email
  filter :display_name
  filter :created_at
  filter :approved_at
  config.sort_order = 'created_at_desc'

  controller do
    def update
      @comment = Comment.find(params[:id])
      original_attrs = @comment.attributes

      if @comment.update(permitted_params[:comment])
        new_attrs = @comment.attributes
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', original_attrs, new_attrs)

        flash[:notice] = "Comment was successfully updated."
        redirect_to admin_blog_post_comments_path(@comment.blog_post_id)
      else
        render 'edit'
      end
    end
  end

  index do
    selectable_column

    column :id
    column 'Blog post' do |comment|
      comment.blog_post.title
    end
    column :display_name
    column :email
    column :ip
    column :created_at do |comment|
      comment.created_at.strftime("%B, %e %Y %H:%M")
    end
    column :approved_at do |comment|
      comment.approved_at.present? ? comment.approved_at.strftime("%B, %e %Y %H:%M") : nil
    end

    actions
  end
end