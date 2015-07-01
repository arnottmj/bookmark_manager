require './app/models/user'

describe User do

  let!(:user) do
    User.create(user_params)
  end

  it 'authenticates when given a valid email address and password' do
    authenticated_user = User.authenticate(email: user.email, password: user.password)
    expect(authenticated_user).to eq user
  end

  def user_params
    {email: 'test@test.com',
     password: 'secret1234',
     password_confirmation: 'secret1234'}
  end

end
