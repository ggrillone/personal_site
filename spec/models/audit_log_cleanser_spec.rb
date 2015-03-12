require 'rails_helper'

describe AuditLogCleanser do
  describe '.cleanse_list' do
    let(:single_level_array) {
      [
        { name: 'Joe', password: 'Secure!' },
        { name: 'Jane', password: '!Secure!' }
      ]
    }
    let(:blacklist) {
      [:password]
    }

    it 'should ONLY remove the blacklisted attributes from a 1 level array of objects' do
      expected_result = [
        { name: 'Joe' },
        { name: 'Jane' }
      ]

      expect{
        AuditLogCleanser.cleanse_list(single_level_array, blacklist)
      }.to eq(expected_result)
    end
  end

  describe '.cleanse_object' do
    let(:single_level_object) {
      {
        first_name: 'Joe',
        last_name: 'Schmo',
        password: 'password',
        password_confirmation: 'password',
        credit_card_number: 1234456677
      }
    }
    let(:single_level_object_blacklist) {
      [:password, :password_confirmation, :credit_card_number]
    }
    let(:two_level_object) {
      {
        first_name: 'Joe',
        last_name: 'Schmo',
        password: 'password',
        password_confirmation: 'password',
        siblings: [
          { name: 'Jane Schmo', address: '123 Kate Upton Way' },
          { name: 'George Schmo', address: '124 Kate Upton Way' }
        ]
      }
    }
    let(:two_level_object_blacklist) {
      [:password, :password_confirmation, siblings: [:address]]
    }

    it 'should remove the ONLY blacklisted attributes from a 1 level object' do
      expected_result = {
        first_name: 'Joe',
        last_name: 'Schmo'
      }

      expect{
        AuditLogCleanser.cleanse_object(single_level_object, single_level_object_blacklist)
      }.to eq(expected_result)
    end

    it 'should remove ONLY the blacklisted attributes from an object 2 levels deep' do
      expected_result = {
        first_name: 'Joe',
        last_name: 'Schmo',
        siblings: [
          { name: 'Jane Schmo' },
          { name: 'George Schmo' }
        ]
      }

      expect{
        AuditLogCleanser.cleanse_object(two_level_object, two_level_object_blacklist)
      }
    end
  end

  describe '.cleanse' do
    let!(:tag) { Fabricate(:tag) }
    let!(:blog_post) { Fabricate(:blog_post, title: 'A blog post') }
    let!(:blog_post_tag) { Fabricate(:blog_post_tag, tag_id: tag.id, blog_post_id: blog_post.id) }
    let(:object_to_cleanse) {
      {
        blog_post: blog_post.attributes,
        tags: blog_post.tags.map(&:attributes)
      }
    }
    let(:blacklist) {
      [
        blog_post: [:is_approved, :created_at, :updated_at],
        tags: [:created_at, :updated_at]
      ]
    }

    it 'should be clean' do
      expected_result = {
        blog_post: {
          id: blog_post.id,
          admin_user_id: blog_post.admin_user_id,
          body: blog_post.body,
          title: blog_post.title,
          cover_image: blog_post.cover_image,
          summary: blog_post.summary,
          live_demo_url: blog_post.live_demo_url,
          live_demo_url_text: blog_post.live_demo_url_text,
          github_source: blog_post.github_source,
          cover_image_alt_text: blog_post.cover_image_alt_text
        },
        tags: [{
          id: tag.id,
          admin_user_id: tag.admin_user_id,
          name: tag.name
        }]
      }

      expect{
        AuditLogCleanser.cleanse(object_to_cleanse, blacklist)
      }.to eq(expected_result)
    end
  end
end
