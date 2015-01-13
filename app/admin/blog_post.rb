ActiveAdmin.register BlogPost do
  permit_params :admin_user_id, :body, :title, :cover_image, :summary, :live_demo_url,
                  :live_demo_url_text, :github_source, :cover_image_alt_text,
                  :tags, :is_approved, blog_post_tags_attributes: [:tag_id]
  actions :all
  includes :comments, :tags
  filter :title
  filter :tags
  filter :created_at
  filter :updated_at
  config.sort_order = 'created_at_desc'

  scope :all, default: true
  scope :approved
  scope :not_approved

  controller do
    def create
      blog_post_tags_attributes = JSON.parse(params[:blog_post][:blog_post_tags_attributes])
      tags = params[:blog_post][:tags]
      params[:blog_post].delete(:blog_post_tags_attributes)
      params[:blog_post].delete(:tags) # need to delete temporarily to save it properly
      @blog_post = BlogPost.create(permitted_params[:blog_post])
      # only build the child tags for the blog post if tags are passed in, otherwise we get
      # an error.
      @blog_post.blog_post_tags.build(blog_post_tags_attributes) if blog_post_tags_attributes.present?

      if @blog_post.save
        params[:blog_post][:tags] = tags
        # Auditing
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', nil, nil)
        flash[:notice] = 'Blog post was successfully created.'
        redirect_to admin_blog_posts_path
      else
        @blog_post.destroy # rollback blog post
        render 'new'
      end
    end

    def update
      blog_post_tags_attributes = JSON.parse(params[:blog_post][:blog_post_tags_attributes])
      params[:blog_post].delete(:blog_post_tags_attributes)
      params[:blog_post].delete(:tags)
      @blog_post = BlogPost.find(params[:id])
      original_attrs = @blog_post.attributes
      original_attrs['tags'] = @blog_post.tags.map(&:name)

      if @blog_post.update(permitted_params[:blog_post])
        # destroy previous children, because otherwise it will append duplicate tags
        @blog_post.blog_post_tags.destroy_all
        # only build the child tags for the blog post if tags are passed in, otherwise we get
        # an error.
        @blog_post.update_attributes({ blog_post_tags_attributes: blog_post_tags_attributes }) if blog_post_tags_attributes.present?

        if @blog_post.save
          @blog_post = BlogPost.find(params[:id])
          new_attrs = @blog_post.attributes
          new_attrs['tags'] = @blog_post.tags.map(&:name)
          AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', original_attrs, new_attrs)

          flash[:notice] = 'Blog post was successfully updated.'
          redirect_to admin_blog_post_path(@blog_post.id)
        else
          render 'edit'
        end
      else
        render 'edit'
      end
    end

    def destroy
      @blog_post = BlogPost.find(params[:id])

      if @blog_post.delete
        AuditLog.create(AdminUserAudit, current_admin_user.id, request, params, 'admin_user_audit_log_blacklist.yml', nil, nil)
        flash[:notice] = "Blog post successfully deleted."
        redirect_to admin_blog_posts_path
      else
        flash[:alert] = "Blog post failed to delete."
        redirect_to :back
      end
    end
  end

  index do
    selectable_column

    column :id
    column :title
    column :is_approved
    column "Live demo" do |blog_post|
      link_to blog_post.live_demo_url_text, blog_post.live_demo_url, target: '_blank'
    end
    column :github_source do |blog_post|
      link_to 'Github source', blog_post.github_source, target: '_blank'
    end
    column 'Tags' do |blog_post|
      blog_post.tags.map(&:name).join(', ')
    end
    column 'Comments' do |blog_post|
      link_to blog_post.comments.count, admin_blog_post_comments_path(blog_post.id)
    end
    column :created_at
    column :updated_at

    actions
  end

  show do
    div do
      h2 link_to 'Comments', admin_blog_post_comments_path(blog_post.id)
    end

    attributes_table do
      row :id
      row 'Author' do
        blog_post.admin_user.email
      end
      row :title
      row :is_approved
      row :summary
      row :body
      row :cover_image do
        image_tag blog_post.cover_image, alt: blog_post.cover_image_alt_text
      end
      row 'Cover image path' do
        blog_post.cover_image
      end
      row :live_demo_url
      row :live_demo_url_text
      row :github_source
      row 'Tags' do
        blog_post.tags.map(&:name).join(', ')
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    script :src => javascript_path('blog_posts.js'), :type => 'text/javascript'

    f.semantic_errors *f.object.errors.keys

    f.inputs 'Blog post details' do
      f.input :title
      f.input :is_approved
      f.input :summary
      f.input :body
      f.input :cover_image
      f.input :cover_image_alt_text
      f.input :live_demo_url
      f.input :live_demo_url_text
      f.input :github_source
      f.input 'Tags', input_html: { value: "#{f.object.tags.count == 0 ? nil : f.object.tags.map(&:name).join(',')}", id: 'blog-post-tags', name: 'blog_post[tags]' }
      # used to post the ids of the tags chosen. the tagit plugin on lets you display
      # a text label and uses the value. So when this form is submitted, the value
      # on this hidden field is set to the tag ids that correspond to the tag text labels.
      f.input 'blog_post_tags', as: :hidden, input_html: { name: 'blog_post[blog_post_tags_attributes]', id: 'tags-hidden' }
      f.input :admin_user_id, as: :hidden, input_html: { value: current_admin_user.id }
    end

    f.actions

    # data for form, stores all tag names to feed
    # into jquery tagit
    div id: 'tag-labels', "data-tags" => "#{Tag.all.map(&:name)}"
    div id: 'tags-data', "data-tags" => "#{(Tag.all.map { |t| { id: t.id, name: t.name } }).to_json}"
  end
end