require 'sinatra/base'
require_relative 'data_mapper_setup'

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


end
