ActiveAdmin.register BlogPost do
  permit_params :body, :title, :cover_image, :summary, :live_demo_url,
                  :live_demo_url_text, :github_source, :cover_image_alt_text,
                  :is_approved
  actions :all
  filter :title
  filter :tags
  filter :created_at
  filter :updated_at

  scope :all, default: true
  scope :approved
  scope :not_approved

  controller do
    def create
      @blog_post = BlogPost.new(permitted_params[:blog_post])
      @blog_post.admin_user_id = current_admin_user.id

      if @blog_post.save
        flash[:notice] = 'Blog post was successfully created.'
        redirect_to admin_blog_posts_path
      else
        render 'new'
      end
    end
  end

  index do
    selectable_column

    column :id
    column :title
    column :is_approved
    column :live_demo_url
    column :live_demo_url_text
    column :github_source
    column 'Comments' do |blog_post|
      blog_post.comments.count
    end
    column :created_at
    column :updated_at

    actions
  end

  show do
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
      row :created_at
      row :updated_at
    end
  end

  form do |f|
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
    end

    f.actions
  end
end