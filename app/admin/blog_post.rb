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
end