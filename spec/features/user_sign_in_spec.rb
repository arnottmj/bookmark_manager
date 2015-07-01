require 'spec_helper'

feature 'User sign in' do

  let(:user) do
    User.create(user_params)
  end

  scenario 'with correct credentials' do
    sign_in user
    expect(page).to have_content "Welcome, #{user.email}"
  end

  def user_params
    {email: 'user@example.com',
     password: 'secret1234',
     password_confirmation: 'secret1234'}
  end

end
