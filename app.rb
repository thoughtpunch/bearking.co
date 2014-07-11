require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "rack-flash"


class BearKingApp < Sinatra::Base

  # Configuration
  set :database, "sqlite3:///bearking.sqlite3"
  set :sessions, true
  set :server, :puma
  enable :sessions
  
  get '/' do
    return 'It works!'
  end
end
