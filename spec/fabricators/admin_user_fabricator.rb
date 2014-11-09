Fabricator(:admin_user) do
  email                   Faker::Internet.email
  password                'Password01'
  password_confirmation   'Password01'
end