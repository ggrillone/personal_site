Fabricator(:admin_user_audit) do
  admin_user_id   { Fabricate(:admin_user).id }
  ip              { Faker::Internet.ip_v4_address }
  action          'PostsController#create'
  data do
    {
      raw_data: {
        body: Faker::Lorem.paragraph(9),
        title: Faker::Hacker.say_something_smart,
        cover_image: Faker::Avatar.image,
        summary: Faker::Lorem.sentence,
        live_demo_url: Faker::Internet.url,
        live_demo_url_text: Faker::App.name,
        github_source: Faker::Internet.url
      }.to_json
    }
  end
end