require 'rails_helper'

describe Comparator do
  describe '.compare_model_attributes' do
    let!(:tag) { Fabricate(:tag) }
    let!(:tag2) { Fabricate(:tag) }
    let!(:blog_post) { Fabricate(:blog_post, title: 'A blog post') }
    let!(:blog_post_tag) { Fabricate(:blog_post_tag, tag_id: tag.id, blog_post_id: blog_post.id) }

    it 'should return which attributes changed' do
      original_attributes = blog_post.attributes
      original_attributes['tags'] = blog_post.tags.map(&:name)
      blog_post.update(title: 'A good blog post')
      BlogPostTag.create(blog_post_id: blog_post.id, tag_id: tag2.id)
      blog_post_after_update = BlogPost.find(blog_post.id)
      new_attributes = blog_post_after_update.attributes
      new_attributes['tags'] = blog_post_after_update.tags.map(&:name)

      expected_diff = {
        title: { original_val: 'A blog post', new_val: 'A good blog post' },
        tags: { original_vals: [tag.name], new_vals: [tag.name, tag2.name] },
        updated_at: { original_val: original_attributes["updated_at"], new_val: new_attributes["updated_at"] }
      }

      expect(Comparator.compare_model_attributes(original_attributes, new_attributes)).to eq(expected_diff)
    end
  end

  describe '.compare_hash' do
    let(:first_hash) {
      {
        id: 1,
        name: 'paul',
        email: 'paul@gmail.com',
        role: 'admin'
      }
    }

    let(:second_hash) {
      {
        id: 1,
        name: 'Paul',
        email: 'Paul@gmail.com',
        role: 'tester'
      }
    }

    let(:expected_diff) {
      {
        name: { original_val: 'paul', new_val: 'Paul' },
        email: { original_val: 'paul@gmail.com', new_val: 'Paul@gmail.com' },
        role: { original_val: 'admin', new_val: 'tester' }
      }
    }

    it 'should return the difference of 2 hashes' do
      expect(Comparator.compare_hashes(first_hash, second_hash)).to eq(expected_diff)
    end
  end

  describe '.compare_lists' do
    let(:first_list) {
      ['tag1', 'tag2']
    }

    let(:second_list) {
      ['tag2', 'tag3', 'tag4']
    }

    let(:expected_diff) {
      {
        original_vals: ['tag1', 'tag2'],
        new_vals: ['tag2', 'tag3', 'tag4']
      }
    }

    it 'should return the expected difference of the 2 lists' do
      expect(Comparator.compare_lists(first_list, second_list)).to eq(expected_diff)
    end
  end

  describe '.attr_is_an_object' do
    let(:hash_obj) {
      {
        name: 'Some name'
      }
    }

    it 'should return true' do
      expect(Comparator.attr_is_an_object(hash_obj)).to be(true)
    end
  end

  describe '.attr_is_a_list' do
    let(:list) {
      ['a', 'b', 'c']
    }

    it 'should return true' do
      expect(Comparator.attr_is_a_list(list)).to be(true)
    end
  end
end