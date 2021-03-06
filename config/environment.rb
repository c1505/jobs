ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
require 'rack-flash'
Bundler.require(:default, ENV['SINATRA_ENV'])

configure :production do
	db = URI.parse(ENV['DATABASE_URL'] || 'postgres://localhost/mydb')

	ActiveRecord::Base.establish_connection(
			:adapter => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
			:host     => db.host,
			:username => db.user,
			:password => db.password,
			:database => db.path[1..-1],
			:encoding => 'utf8'
	)
end

configure :development do
ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
)
end 

require_all 'app'
