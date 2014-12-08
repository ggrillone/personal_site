Fabricator(:tag) do
  admin_user_id   { Fabricate(:admin_user).id }
  name            { sequence(:name) { |i| "#{Faker::Hacker.abbreviation}-#{i}" } }
end