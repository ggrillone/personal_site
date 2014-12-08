Fabricator(:comment) do
  blog_post_id      { Fabricate(:blog_post).id }
  email             { Faker::Internet.email }
  display_name      { Faker::Name.name }
  ip                { Faker::Internet.ip_v4_address }
  body              { Faker::Lorem.sentence }
  approved_at       { Time.now.utc }
end