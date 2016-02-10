ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
require 'rack-flash'
Bundler.require(:default, ENV['SINATRA_ENV'])

configure :development do 
  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
  )
end

configure :production do 
  ActiveRecord::Base.establish_connection(ENV['SINATRA_ENV'] || 'postgres://localhost/mydb')
end
require_all 'app'
