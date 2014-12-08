ActiveAdmin.register Comment do
  belongs_to :blog_post
  permit_params :blog_post_id, :email, :display_name, :ip, :body
  actions :all, except: [:new, :create]

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

    actions
  end
end