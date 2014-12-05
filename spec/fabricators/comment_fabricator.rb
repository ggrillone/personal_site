Fabricator(:comment) do
  post_id           { Fabricate(:post).id }
  email             { Faker::Internet.email }
  display_name      { Faker::Name.name }
  ip                { Faker::Internet.ip_v4_address }
  body              { Faker::Lorem.sentence }
end