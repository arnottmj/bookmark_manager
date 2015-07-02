# require 'spec_helper'

feature 'User signs out' do

  before(:each) do
    @user = User.create(user_params)
  end

  scenario 'while being signed in' do
    sign_in(@user)
    click_button 'Sign out'
    expect(page).to have_content('goodbye!') # where does this message go?
    expect(page).not_to have_content('Welcome, test@test.com')
  end

  def user_params
    {email: 'test@test.com',
     password: 'test',
     password_confirmation: 'test'}
  end

end
