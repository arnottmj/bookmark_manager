feature 'Password reset' do

  before(:each) do
    User.create(user_params)
  end

  scenario 'requesting a password reset' do
    send_email = double :send_email
    expect(SendResetEmail).to receive(:new) {send_email}
    expect(send_email).to receive(:call)
    visit '/password_reset'
    fill_in 'email', with: user_params[:email]
    click_button 'Reset password'
    user = User.first(email: user_params[:email])
    expect(user.password_token).not_to be_nil
    expect(page).to have_content 'Check your emails'
  end

  scenario 'resetting password' do
    user = User.first
    user.password_token = 'token'
    user.save
    visit "/users/password_reset/#{user.password_token}"
    expect(page.status_code).to eq 200
    expect(page).to have_content 'Enter a new password'
  end

  scenario 'updating password in databse' do
    user = User.first
    user.password_token = 'token'
    user.save
    digest = user.password_digest
    visit "/users/password_reset/#{user.password_token}"
    fill_in 'password', with: 'newsecret'
    fill_in 'password_confirmation', with: 'newsecret'
    click_button 'Reset password'
    retrieve_user = User.first
    expect(retrieve_user.password_digest).not_to eq digest
  end


  def user_params
    {email: 'test@test.com',
     password: 'secret1234',
     password_confirmation: 'secret1234'}
  end
end
