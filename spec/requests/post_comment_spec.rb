require 'rails_helper'

RSpec.describe 'PostComment' do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:blog_post) { Fabricate(:post, admin_user_id: admin_user.id) }
  let!(:comment) { Fabricate(:comment, post_id: blog_post.id) }
  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/posts/:id/comments' do
    before { get admin_post_comments_path(blog_post.id) }

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(comment.id.to_s)
    end

    it 'should render the post for the comment' do
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
      expect(response.body).to include(comment.created_at)
    end
  end

  describe 'GET /admin/posts/:id/comments/:id' do
    before { get admin_post_comment_path(blog_post.id, comment.id) }

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

  describe 'GET /admin/posts/:id/comments/:id/edit' do
    before { get edit_admin_post_comment_path(blog_post.id, comment.id) }

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'should respond with a status code of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'PUT /admin/posts/:id/comments/:id' do
    before do
      put admin_post_comment_path(blog_post.id, comment.id), comment: {
        body: 'hello world'
      }
    end

    it 'should redirect to the comments index page' do
      expect(response).to redirect_to(admin_post_comments_path(blog_post.id))
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should render a success messsage' do
      expect(response.body).to include('Comment successfully updated')
    end

    it 'should update the body attribute' do
      expect(Comment.find(comment.id).body).to be('hello world')
    end
  end

  describe 'DELETE /admin/posts/:id/comments' do
    before { delete admin_post_comment_path(blog_post.id, comment.id) }

    it 'should redirect to the comments index page' do
      expect(response).to redirect_to(admin_post_comments_path(blog_post.id))
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render a success message' do
      expect(response.body).to include('Comment was successfully deleted')
    end

    it 'should delete the comment' do
      expect(Comment.all.count).to be(0)
    end
  end
end