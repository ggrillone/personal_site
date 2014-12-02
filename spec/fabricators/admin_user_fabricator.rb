Fabricator(:admin_user) do
  email                   { Faker::Internet.free_email("#{Faker::Name.first_name.downcase}.#{Faker::Name.last_name.downcase}#{Faker::Number.digit}") }
  password                'Password01'
  password_confirmation   'Password01'
end