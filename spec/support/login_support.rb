module LoginSupport
  def sign_in_request_as(user)
    post sessions_path, params: { email: user.email, password: user.password } # authenticate the user
    follow_redirect! if response.redirect?
  end

  def sign_in_as(user)
    visit root_path

    click_link "Log in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Login" # asynchronous when js: true

    # wait until login completes
    expect(page).to have_current_path(root_path)
  end
end
