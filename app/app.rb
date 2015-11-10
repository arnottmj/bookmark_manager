require 'sinatra/base'
require 'sinatra/flash'
require './app/data_mapper_setup'
require './lib/send_reset_email'


class BookmarkManager < Sinatra::Base
  enable :sessions
  register Sinatra::Flash
  set :session_secret, 'super secret'
  use Rack::MethodOverride

  get '/' do
    redirect '/users/new'
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    all_tags = params[:tag].split(' ')

    all_tags.each do |tag|
      tag = Tag.create(text: tag)
      link.tags << tag
    end

    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(text: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    @user = User.new(email: params[:email],
                     password: params[:password],
                     password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/links')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/password_reset' do
    erb :'users/password_reset'
  end

  post '/password_reset' do
    user = User.first(email: params[:email])

    if user 
      @email = params[:email]
      user.password_token = generate_password_token
      user.save
      client = Mailgun::Client.new ENV['MAILGUN_KEY']
      send_email = SendResetEmail.new(user, client)
      send_email.call
    end

    erb :'users/password_reset'
  end

  get '/users/password_reset/:token' do
    @token = params[:token] if User.first(password_token: params[:token])
    erb :'users/password_reset'
  end

  post '/users/password_reset/:token' do
    @token = params[:token]
    user = User.first(password_token: params[:token])
    user.update(:password => params[:password],
                :password_confirmation => params[:password_confirmation])

    if user.save
      user.password_token = nil
      user.save
      redirect to('/links')
    else
      flash.now[:errors] = user.errors.full_messages
      erb :'users/pasword_reset'
    end
  end

  get '/sessions/new' do
    erb :'sessions/new'
  end

  delete '/sessions' do
    session.clear
    erb :'sessions/goodbye'
  end


  post '/sessions' do
    user = User.authenticate(email: params[:email], password: params[:password])

    if user
      session[:user_id] = user.id
      redirect to('/links')
    else
      flash[:errors] = ['The email or password is incorrect']
      erb :'sessions/new'
    end
  end

  helpers do
    def current_user
      @user ||= User.first(id: session[:user_id]) if session[:user_id]
    end

    def generate_password_token
      (0...50).map { ('A'..'Z').to_a[rand(26)] }.join
    end
  end
end
