def login(email, password)
  post admin_user_session_path, admin_user: {
    email: email,
    password: password
  }
  follow_redirect!
end