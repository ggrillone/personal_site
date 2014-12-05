require 'rails_helper'

RSpec.describe Post do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:blog_post) { Fabricate(:post) }
  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/posts' do
    before { visit admin_posts_path }

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(blog_post.id.to_s)
    end

    it 'should render the title attribute' do
      expect(response.body).to include(blog_post.title)
    end

    it 'should render the live_demo_url attribute' do
      expect(response.body).to include(blog_post.live_demo_url)
    end

    it 'should render the live_demo_url_text attribute' do
      expect(response.body).to include(blog_post.live_demo_url_text)
    end

    it 'should render the github_source attribute' do
      expect(response.body).to include(blog_post.github_source)
    end
  end

  describe 'GET /admin/posts/:id' do
    before { get admin_post_path(blog_post.id) }

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the body attribute' do
      expect(response.body).to include(blog_post.body)
    end

    it 'should render the cover_image attribute' do
      expect(reponse.body).to include(blog_post.cover_image)
    end

    it 'should render the summary attribute' do
      expect(response.body).to include(blog_post.summary)
    end
  end

  describe 'GET /admin/posts/new' do
    before { get new_admin_post_path }

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'POST /admin/posts' do
    before do
      post admin_posts_path, post: {
        admin_user_id:        admin_user.id,
        body:                 'body text',
        title:                'title text',
        cover_image:          '/assets/post.png',
        summary:              'cool post bruh',
        live_demo_url:        'livedemo.com',
        live_demo_url_text:   'click here',
        github_source:        'github.com/awesome'
      }
    end

    it 'should redirect to the posts index page' do
      expect(response).to redirect_to(admin_posts_path)
    end

    it 'should render a success message' do
      expect(response.body).to include("Post was successfully created")
    end

    it 'should response with a status of 302' do
      expect(response.status).to be(302)
    end
  end

  describe 'GET /admin/posts/:id/edit' do
    before { get edit_admin_post_path(blog_post .id) }

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'should response with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'PUT /admin/posts/:id' do
    before do
      put admin_post_path(blog_post.id), post: {
        title: 'My new title'
      }
    end

    it 'should redirect to the post show page' do
      expect(response).to redirect_to(admin_post_path(blog_post.id))
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should render a succeess message' do
      expect(response.body).to include('Post was successfully updated')
    end

    it 'should update the title attribute' do
      expect(Post.find(blog_post.id).title).to be('My new title')
    end
  end

  describe 'DELETE /admin/posts/:id' do
    before { delete admin_post_path(blog_post.id) }

    it 'should redirect to the post index page' do
      expect(response).to redirect_to(admin_posts_path)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end
  end
end