# ENV["RACK_ENV"] ||= "development"

require_relative 'data_mapper_setup'
require 'sinatra/base'

class BookmarkManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'yes'

  get '/' do
    redirect '/links'
  end

  get '/links' do
    @links = Link.all
    erb(:'links/index')
  end

  get '/links/new' do
    erb(:'links/add_link')
  end

  post '/links' do
    link = Link.new(url: params[:url],     # 1. Create a link
                  title: params[:title])
    tag  = Tag.first_or_create(name: params[:tags])  # 2. Create a tag for the link
    link.tags << tag                       # 3. Adding the tag to the link's DataMapper collection.
    link.save                              # 4. Saving the link.
    redirect to('/links')
  end

  run! if app_file == $0
end
