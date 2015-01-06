require 'rails_helper'

RSpec.describe AdminUserAudit do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:admin_user_audit) { Fabricate(:admin_user_audit) }

  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/admin_user_audits' do
    before { get admin_admin_user_audits_path }

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
      expect(response.body).to include(admin_user_audit.created_at.strftime("%B, %e %Y %H:%M"))
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
  end

  describe 'Create audit record when updating an AdminUser resource' do
    it 'should create a new audit record' do
      expect{
        put admin_admin_user_path(admin_user.id), admin_user: {
          email: 'yoyoyo1@domain.com',
        }
      }.to change{AdminUserAudit.count}.by(1)
    end
  end

  describe 'Logging changed attributes when updating and AdminUser resource' do
    let(:original_email) { admin_user.email }

    before do
      put admin_admin_user_path(admin_user.id), admin_user: {
        email: 'somenewemail1@domain.com',
      }
    end

    it 'should log it as a update action' do
      expect(AdminUserAudit.last.action).to eq('AdminUser#update')
    end

    it 'should log the id of the admin user that performed the create' do
      expect(AdminUserAudit.last.admin_user_id).to eq(admin_user.id)
    end

    it 'should include the previous value of the email address' do
      expect(AdminUserAudit.last.data.to_s).to include(original_email)
    end

    it 'should include the new value of the email address' do
      expect(AdminUserAudit.last.data.to_s).to include('somenewemail1@domain.com')
    end
  end
end