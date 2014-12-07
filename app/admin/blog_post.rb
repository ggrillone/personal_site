ActiveAdmin.register BlogPost do
  permit_params :body, :title, :cover_image, :summary, :live_demo_url,
                  :live_demo_url_text, :github_source
  actions :all

  controller do
    def create
      @blog_post = BlogPost.new(permitted_params)
      @blog_post.admin_user_id = current_admin_user.id

      if @blog_post.save
        flash[:notice] = 'Blog post was successfully created.'
      else
        render 'new'
      end

      redirect_to admin_blog_posts_path
    end
  end
end