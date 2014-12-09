Fabricator(:social_media) do
  url_href        { Faker::Internet.url }
  url_image       ['github.png', 'linkedin.png'].sample
  name            { Faker::Name.name }
end