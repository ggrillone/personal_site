Fabricator(:social_media) do
  url_href        Faker::Internet.url
  url_image       Faker::Internet.url
  name            Faker::Name.name
end