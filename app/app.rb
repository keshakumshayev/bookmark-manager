# ENV["RACK_ENV"] ||= "development"

require_relative 'data_mapper_setup'
require 'sinatra/base'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'yes'

  get '/' do
    redirect '/links/new'
  end

  get '/links' do
    @links = Link.all
    erb(:'links/index')
  end

  get '/links/new' do
    erb(:'links/add_link')
  end

  post '/links/:tag' do
    redirect "/links/#{params[:tag]}"
  end

  get '/links/:tag' do
    @links = Tag.all({name: params[:tag]}).links
    erb(:'links/index')
  end

  post '/links' do
    link = Link.new(url: params[:url],     # 1. Create a link
                  title: params[:title])
    tag  = Tag.first_or_create(name: params[:tags])  # 2. Create a tag for the link
    link.tags << tag
    link.save
    redirect to('/links')
  end

  run! if app_file == $0
end
