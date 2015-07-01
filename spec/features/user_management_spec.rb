require 'spec_helper'

feature 'User sign up' do

  # Strictly speaking, the tests that check the UI
  # (have_content, etc.) should be separate from the tests
  # that check what we have in the DB since these are separate concerns
  # and we should only test one concern at a time.

  # However, we are currently driving everything through
  # feature tests and we want to keep this example simple.

  before(:each) { @user = User.new(user_params)}

  scenario 'I can sign up as a new user' do
    expect { sign_up @user }.to change(User, :count).by(1)
    expect(page).to have_content('Welcome, alice@example.com')
    expect(User.first.email).to eq('alice@example.com')
  end

  scenario 'with a password that does not match' do
    @user.password_confirmation = 'wrong'
    expect { sign_up @user }.not_to change(User, :count)
    expect(current_path).to eq('/users') # current_path is a helper provided by Capybara
    expect(page).to have_content('Password does not match the confirmation')
  end

  scenario 'with an email that is already registered' do
    sign_up(@user)
    expect { sign_up(@user) }.to change(User, :count).by(0)
    expect(page).to have_content('This email is already taken')
  end

  def sign_up(user)
    visit '/users/new'
    fill_in :email,    with: user.email
    fill_in :password, with: user.password
    fill_in :password_confirmation, with: user.password_confirmation
    click_button 'Sign up'
  end

  def user_params
    {email: 'alice@example.com', password: '12345678', password_confirmation: '12345678'}
  end

  # email: 'alice@example.com',
  #            password: '12345678',
  #            password_confirmation: '12345678'


end
