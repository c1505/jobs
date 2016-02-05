require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do 
    "Hello World"
    "login link here"
  end

  get '/users/signup' do 
    erb :"/users/new"
  end

  post '/users' do 
    @user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
    @user.save
    session[:id] = @user.id
    erb :"/users/show"
  end

  get '/users/:id' do 
    @user = User.find(params[:id])
    erb :"/users/show"
  end

  get '/users' do    #usefull to have to look at them, but will likely delete later
    @users = User.all
    erb :"/users/index"
  end
  #suppose this could be an admin view

  get '/users/:id/edit' do 
    @user = User.find(params[:id])
    erb :"/users/edit"
  end

  patch '/users/:id' do #flash mesage for changes saved or not
    user = User.find(params[:id])
    user.update(name: params[:name], username: params[:username], email: params[:email])
    redirect "/users/#{user.id}"
  end

  get '/users/login' do 
    erb :"/users/login"
  end

  get '/jobs' do
    @jobs = Job.all 
    erb :"/jobs/index"
  end
end