ActiveAdmin.register BlogPost do
  permit_params :body, :title, :cover_image, :summary, :live_demo_url,
                  :live_demo_url_text, :github_source
  actions :all
  filter :title
  filter :tags
  filter :created_at
  filter :updated_at

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

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Blog post details' do
      f.input :title
      f.input :summary
      f.input :body
      f.input :cover_image
      f.input :live_demo_url
      f.input :live_demo_url_text
      f.input :github_source
    end

    f.actions
  end
end