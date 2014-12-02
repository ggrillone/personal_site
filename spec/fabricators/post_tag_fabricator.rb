Fabricator(:post_tag) do
  post_id      { Fabricate(:post).id }
  tag_id       { Fabricate(:tag).id }
end