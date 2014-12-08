Fabricator(:blog_post_tag) do
  blog_post_id      { Fabricate(:blog_post).id }
  tag_id            { Fabricate(:tag).id }
end