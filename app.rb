require "bundler/setup"
require "sinatra"
require "sinatra/activerecord"
require "rack-flash"

# Configuration
set :database, "sqlite3:///bearking.sqlite3"
set :sessions, true
enable :sessions