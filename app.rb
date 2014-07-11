require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"

class BearKingApp < Sinatra::Base

  # Configuration
  set :database, "sqlite3:///bearking.sqlite3"
  set :sessions, true
  set :server, :puma
  enable :sessions

  get '/' do
    erb :home
  end
end
