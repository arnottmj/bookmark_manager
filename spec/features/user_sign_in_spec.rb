require 'spec_helper'

feature 'User sign in' do

  let(:user) do
    User.create(user_params)
  end

  scenario 'with correct credentials' do
    sign_in user
    expect(page).to have_content "Welcome, #{user.email}"
  end

  def sign_in(user)
    visit '/sessions/new'
    fill_in :email,    with: user.email
    fill_in :password, with: user.password
    click_button 'Sign in'
  end

  def user_params
    {email: 'user@example.com',
     password: 'secret1234',
     password_confirmation: 'secret1234'}
  end

end
