require 'rails_helper'

RSpec.describe 'BlogPostComment' do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:blog_post) { Fabricate(:blog_post, admin_user_id: admin_user.id) }
  let!(:comment) { Fabricate(:comment, blog_post_id: blog_post.id) }
  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/blog_posts/:id/comments' do
    before { get admin_blog_post_comments_path(blog_post.id) }

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(comment.id.to_s)
    end

    it 'should render the blog post for the comment' do
      expect(response.body).to include(comment.blog_post.title)
    end

    it 'should render the email attribute' do
      expect(response.body).to include(comment.email)
    end

    it 'should render the ip attribute' do
      expect(response.body).to include(comment.ip)
    end

    it 'should render the display_name attribute' do
      expect(response.body).to include(comment.display_name)
    end

    it 'should render the created_at attribute' do
      expect(response.body).to include(comment.created_at.strftime("%B, %e %Y %H:%M"))
    end
  end

  describe 'GET /admin/blog_posts/:id/comments/:id' do
    before { get admin_blog_post_comment_path(blog_post.id, comment.id) }

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the body attribute' do
      expect(response.body).to include(comment.body)
    end
  end

  describe 'GET /admin/blog_posts/:id/comments/:id/edit' do
    before { get edit_admin_blog_post_comment_path(blog_post.id, comment.id) }

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'should respond with a status code of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'PUT /admin/blog_posts/:id/comments/:id' do
    before do
      put admin_blog_post_comment_path(blog_post.id, comment.id), comment: {
        body: 'hello world unique'
      }
    end

    it 'should redirect to the comments show page' do
      expect(response).to redirect_to(admin_blog_post_comment_path(blog_post.id, comment.id))
      follow_redirect!
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should save the new comment' do
      expect(Comment.find_by_body('hello world unique')).to_not be(nil)
    end

    it 'should update the body attribute' do
      expect(Comment.find(comment.id).body).to eq('hello world unique')
    end
  end

  describe 'DELETE /admin/blog_posts/:id/comments' do
    before { delete admin_blog_post_comment_path(blog_post.id, comment.id) }

    it 'should redirect to the comments index page' do
      expect(response).to redirect_to(admin_blog_post_comments_path(blog_post.id))
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should delete the comment' do
      expect(Comment.all.count).to be(0)
    end
  end
end