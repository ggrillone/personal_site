ActiveAdmin.register Comment do
  belongs_to :blog_post
  permit_params :blog_post_id, :email, :display_name, :ip, :body
  actions :all, except: [:new, :create, :edit, :update]
  includes :blog_post
  filter :email
  filter :display_name
  filter :created_at
  filter :approved_at
  config.batch_actions = true
  config.sort_order = 'created_at_desc'
  scope :all, default: true
  scope :approved
  scope :not_approved

  batch_action :approve do |ids|
    @comments = Comment.where(id: ids)
    original_attrs = @comments.map(&:attributes)
    blog_post_id = @comments.first.blog_post_id

    if @comments.update_all(approved_at: Time.now.utc)
      new_attrs = @comments.map(&:attributes)
      AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', original_attrs, new_attrs)
      flash[:notice] = "#{@comments.count} comments were successfully approved."
    else
      flash[:alert] = "Comments failed to be approved."
    end

    redirect_to admin_blog_post_comments_path(blog_post_id)
  end

  batch_action :unapprove do |ids|
    @comments = Comment.where(id: ids)
    original_attrs = @comments.map(&:attributes)
    blog_post_id = @comments.first.blog_post_id

    if @comments.update_all(approved_at: nil)
      new_attrs = @comments.map(&:attributes)
      AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', original_attrs, new_attrs)
      flash[:notice] = "#{@comments.count} comments were successfully unapproved."
    else
      flash[:alert] = "Comment failed to be unapproved."
    end

    redirect_to admin_blog_post_comments_path(blog_post_id)
  end

  controller do
    def destroy
      @comment = Comment.find(params[:id])
      blog_post_id = @comment.blog_post_id

      if @comment.delete
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', nil, nil)
        flash[:notice] = 'Comment was successfully deleted.'
        redirect_to admin_blog_post_comments_path(blog_post_id)
      else
        flash[:alert] = 'Comment failed to delete.'
        redirect_to :back
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