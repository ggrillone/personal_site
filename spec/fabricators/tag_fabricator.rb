Fabricator(:tag) do
  admin_user_id   { Fabricate(:admin_user).id }
  name            { "#{Faker::Hacker.abbreviation}-#{Faker::Number.digit}" }
end