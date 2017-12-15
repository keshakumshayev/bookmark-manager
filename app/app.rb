ENV["RACK_ENV"] ||= "development"

require_relative 'data_mapper_setup'
require 'sinatra/base'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'yes'

  get '/' do
    erb(:'links/home')
  end

  get '/links/new' do
    erb(:'links/add_link')
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

  get '/links' do
    @links = Link.all
    erb(:'links/index')
  end

  post '/links/filter_by_tag' do
    redirect "/links/#{params[:tag]}"
  end

  get '/links/:tag' do
    @links = Tag.all({name: params[:tag]}).links
    erb(:'links/index')
  end

  get '/users/new' do
    erb(:'links/signup')
  end

  post '/users' do
    user = User.create(email: params[:email],
                        password: params[:password])
    session[:user_id] = user.id
    redirect '/links'
  end






  get '/signin' do
    erb(:'links/signin')
  end

  helpers do
   def current_user
     @current_user ||= User.get(session[:user_id])
   end
  end

  run! if app_file == $0
end
