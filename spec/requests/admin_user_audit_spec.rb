require 'rails_helper'

RSpec.describe AdminUserAudit do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:admin_user_audit) { Fabricate(:admin_user_audit) }

  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/admin_user_audits' do
    before { get admin_admin_user_audits }

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status code of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(admin_user_audit.id.to_s)
    end

    it 'should render the admin user email' do
      expect(response.body).to include(admin_user_audit.admin_user.email)
    end

    it 'should render the ip attribute' do
      expect(response.body).to include(admin_user_audit.ip)
    end

    it 'should render the action attribute' do
      expect(response.body).to include(admin_user_audit.action)
    end

    it 'should render the created_at attribute' do
      expect(response.body).to include(admin_user_audit.created_at)
    end
  end

  describe 'GET /admin/admin_user_audits/:id' do
    before { get admin_admin_user_audit_path(admin_user_audit.id) }

    it 'should render the show template' do
      expect(response).to render_template(:show)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the data attribute' do
      expect(response.body).to include(admin_user_audit.data)
    end
  end
end