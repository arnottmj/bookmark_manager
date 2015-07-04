describe SendResetEmail do

  let(:user)         { double :user, password_token: '4nknkj34nkj23n4j32', email:
                       "user@example.com" }
  let(:email_client) { double :email_client }
  subject { SendResetEmail.new(user, email_client) }
  
  it 'passes a recovery message to an email client' do
    message_params = {:from    => 'bookmark_manager@sandbox4fa5555f8b71462eb50e5da4ce964345.mailgun.org',
                      :to      =>  user.email,
                      :subject => 'Bookmark Manager Password Reset Link',
                      :text    => "localhost:9292/users/password_reset/#{user.password_token}"}
    expect(email_client).to receive(:send_message).with('sandbox4fa5555f8b71462eb50e5da4ce964345.mailgun.org',
                                                        message_params)
                                                        
    subject.call
  end
end
