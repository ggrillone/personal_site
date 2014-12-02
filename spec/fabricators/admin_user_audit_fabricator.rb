Fabricator(:admin_user_audit) do
  admin_user_id   { Fabricate(:admin_user).id }
  ip              { Faker::Internet.ip_v4_address }
  action          'PostsController#create'
  data            { Fabricate(:post).to_json }
end