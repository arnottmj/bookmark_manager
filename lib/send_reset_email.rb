require 'mailgun'

class SendResetEmail

  def initialize(user, client)
    @user = user
    @client = client
  end

  def call

    message_params = {:from    => 'bookmark_manager@sandbox4fa5555f8b71462eb50e5da4ce964345.mailgun.org',
                      :to      =>  @user.email,
                      :subject => 'Bookmark Manager Password Reset Link',
                      :text    => "localhost:9292/users/password_reset/#{@user.password_token}"}

    @client.send_message 'sandbox4fa5555f8b71462eb50e5da4ce964345.mailgun.org', message_params
  end
end



