ENV["RACK_ENV"] ||= "development"

require_relative 'data_mapper_setup'
require 'sinatra/base'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'yes'

  get '/' do
    erb(:'links/home')
    # redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb(:'links/index')
  end

  get '/links/new' do
    erb(:'links/add_link')
  end

  post '/links/filter_by_tag' do
    redirect "/links/#{params[:tag]}"
  end

  get '/links/:tag' do
    @links = Tag.all({name: params[:tag]}).links
    erb(:'links/index')
  end

  post '/links' do
    link = Link.new(url: params[:url],     # 1. Create a link
                  title: params[:title])
    params[:tags].split(',').each do |tag|
      link.tags << Tag.first_or_create(name: tag)
    end
    link.save
    redirect to('/links')
  end

  get '/signup' do
    'fail'
  end

  get '/signin' do
    'fail'
  end

  run! if app_file == $0
end
