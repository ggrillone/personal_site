require 'rails_helper'

RSpec.describe Tag do
  let!(:admin_user) { Fabricate(:admin_user) }
  let!(:tag) { Fabricate(:tag) }
  before { login(admin_user.email, admin_user.password) }

  describe 'GET /admin/tags' do
    before { get admin_tags_path }

    it 'should render the index template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render the id attribute' do
      expect(response.body).to include(tag.id.to_s)
    end

    it 'should render the name attribute' do
      expect(response.body).to include(tag.name)
    end

    it 'should render the created_at attribute' do
      expect(response.body).to include(tag.created_at)
    end

    it 'should render the updated_at attribute' do
      expect(response.body).to include(tag.updated_at)
    end
  end

  describe 'GET /admin/tags/new' do
    before { get new_admin_tag_path }

    it 'should render the new template' do
      expect(response).to render_template(:index)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'POST /admin/tags' do
    before do
      post admin_tags_path, tag: {
        admin_user_id: admin_user.id,
        name: 'ruby'
      }
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should redirect to the tag index page' do
      expect(response).to redirect_to(admin_tags_path)
    end

    it 'should render a success message' do
      expect(response.body).to include('Tag was successfully created')
    end
  end

  describe 'GET /admin/tags/:id/edit' do
    before { get edit_admin_tags_path }

    it 'should render the edit template' do
      expect(response).to render_template(:edit)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end
  end

  describe 'PUT /admin/tags/:id' do
    before do
      put admin_tag_path(tag.id), tag: {
        name: 'ruby-on-rails'
      }
    end

    it 'should redirect to the tag index page' do
      expect(response).to redirect_to(admin_tags_path)
    end

    it 'should respond with a status of 302' do
      expect(response.status).to be(302)
    end

    it 'should render a success message' do
      expect(response.body).to include('Tag was successfully updated')
    end

    it 'should update the name attribute' do
      expect(Tag.find(tag.id).name).to be('ruby-on-rails')
    end
  end

  describe 'DELETE /admin/tags/:id' do
    before { delete admin_tag_path(tag.id) }

    it 'should redirect to the tag index page' do
      expect(reponse).to redirect_to(admin_tags_path)
    end

    it 'should respond with a status of 200' do
      expect(response.status).to be(200)
    end

    it 'should render a success messsage' do
      expect(response.body).to include('Tag was successfully deleted')
    end
  end
end