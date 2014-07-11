require 'dotenv'
Dotenv.load

require 'sass/plugin/rack'
use Sass::Plugin::Rack

require './app'

run BearKingApp
