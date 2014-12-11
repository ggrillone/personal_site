Fabricator(:social_media) do
  url_href        { Faker::Internet.url }
  url_href_text   'my link'
  url_image       ['github.png', 'linkedin.png'].sample
  url_image_text  ['github profile', 'linkedin profile'].sample
  name            { Faker::Name.name }
end