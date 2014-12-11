Fabricator(:blog_post) do
  admin_user_id         { Fabricate(:admin_user).id }
  body                  { Faker::Lorem.paragraph(9) }
  title                 { Faker::Commerce.product_name }
  cover_image           'sample.png'
  cover_image_alt_text  'This is a sample image..'
  is_approved           [true, false].sample
  summary               { Faker::Lorem.sentence }
  live_demo_url         { Faker::Internet.url }
  live_demo_url_text    { Faker::App.name }
  github_source         { Faker::Internet.url }
end
