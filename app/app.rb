require 'sinatra/base'

class BookmarkManager < Sinatra::Base

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    tag = Tag.create(text: params[:tag])
    link.tags << tag
    link.save
    redirect to('/links')
  end

  get '/tags/:name' do
    tag = Tag.first(text: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end


end