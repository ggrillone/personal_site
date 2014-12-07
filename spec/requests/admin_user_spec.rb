require 'rails_helper'

RSpec.describe AdminUser do
  let!(:admin_user) { Fabricate(:admin_user) }
  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/admin_users' do
    before { get admin_admin_users_path }

    it 'should render the index tempalte' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status code of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(admin_user.id.to_s)
    end

    it 'should render the email attribute' do
      expect(response.body).to include(admin_user.email)
    end
  end
  
  describe 'GET /admin/admin_users/:id/edit' do
    before { get edit_admin_admin_user_path(admin_user.id) }

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'PUT /admin/admin_users/:id' do
    before do
      put admin_admin_user_path(admin_user.id), admin_user: {
        email: 'mynewemail@gmail.com'
      }
    end

    it 'should respond with a status code of 302' do
      expect(response.status).to be(302)
    end

    it 'should redirect to the index page' do
      expect(response).to redirect_to(admin_admin_users_path)
      follow_redirect!
    end
  end
end