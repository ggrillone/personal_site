require 'rails_helper'

RSpec.describe SocialMedia do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:social_media) { Fabricate(:social_media) }
  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/social_media' do
    before { get admin_social_media_path }

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(social_media.id.to_s)
    end

    it 'should render the name attribute' do
      expect(response.body).to include(social_media.name)
    end

    it 'should render the url_href attribute' do
      expect(response.body).to include(social_media.url_href)
    end

    it 'should render the url_image attribute' do
      expect(response.body).to include(social_media.url_image)
    end

    it 'should render the created_at attribute' do
      expect(response.body).to include(social_media.created_at.strftime("%B, %e %Y %H:%M"))
    end

    it 'should render the updated_at attribute' do
      expect(response.body).to include(social_media.updated_at.strftime("%B, %e %Y %H:%M"))
    end
  end

  describe 'GET /admin/social_media/new' do
    before { get new_admin_social_medium_path }

    it 'should render the new template' do
      expect(response).to render_template(:new)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'POST /admin/social_media' do
    before do
      post admin_social_media_path, social_media: {
        url_href: 'github.com/me',
        url_image: '/assets/github.png',
        name: 'github'
      }
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should redirect to the social media index page' do
      expect(response).to redirect_to(admin_social_media_path)
      follow_redirect!
    end

    it 'should save the social media record' do
      expect(SocialMedia.find_by_name('github')).to_not be(nil)
    end
  end

  describe 'GET /admin/social_media/:id/edit' do
    before { get edit_admin_social_medium_path(social_media.id) }

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'should responsd with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'PUT /admin/social_media/:id' do
    before do
      put admin_social_medium_path(social_media.id), social_media: {
        name: 'My Github profile link'
      }
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should redirect to the social media index page' do
      expect(response).to redirect_to(admin_social_media_path)
      follow_redirect!
    end

    it 'should update the name attribute' do
      expect(SocialMedia.find(social_media.id).name).to eq('My Github profile link')
    end
  end

  describe 'DELETE /admin/social_media/:id' do
    before { delete admin_social_medium_path(social_media.id) }

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should redirect to the social media index page' do
      expect(response).to redirect_to(admin_social_media_path)
      follow_redirect!
    end
  end
end