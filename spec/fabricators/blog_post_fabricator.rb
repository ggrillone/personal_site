Fabricator(:blog_post) do
  admin_user_id         { Fabricate(:admin_user).id }
  body                  { Faker::Lorem.paragraph(9) }
  title                 { Faker::Hacker.say_something_smart }
  cover_image           { Faker::Avatar.image }
  summary               { Faker::Lorem.sentence }
  live_demo_url         { Faker::Internet.url }
  live_demo_url_text    { Faker::App.name }
  github_source         { Faker::Internet.url }
end
