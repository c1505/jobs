require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do 
    "login link here"
  end

  get '/users/signup' do 
    erb :"/users/new"
  end
  
  get '/users/login' do
    if logged_in?
      redirect "/users/#{current_user.id}"
    else
      erb :"/users/login"
    end
  end
  
  post '/users/login' do
    user = User.find_by(username: params[:username])
    if user.authenticate(params[:password])
      session[:id] = user.id
      redirect "/users/#{user.id}"
    else
      redirect "/users/login"
    end
  end
  
  get '/users/logout' do
    session.clear
    redirect '/'
    #is there a point in a conditional to see if logged in and who the current user is?
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



  get '/jobs' do
    @jobs = Job.all 
    erb :"/jobs/index"
  end

  get '/jobs/new' do
    erb :"/jobs/new"
  end

  post '/jobs' do 
    @job = Job.new(title: params[:title], company: params[:company],location: params[:location],salary: params[:salary],body: params[:body],contacts: params[:contacts],company_info: params[:company_info])
    @job.save
    erb :"/jobs/index"
  end

  get '/jobs/:id' do
    @job = Job.find(params[:id])
    erb :"/jobs/show"
  end

  get '/jobs/:id/edit' do 
    @job = Job.find(params[:id])
    erb :"/jobs/edit"
  end

  patch '/jobs/:id' do 
    @job = Job.find(params[:id])
    @job.update(title: params[:title], company: params[:company],location: params[:location],salary: params[:salary],body: params[:body],contacts: params[:contacts],company_info: params[:company_info])
    erb :"/jobs/show"
  end
  
  delete '/jobs/:id/delete' do 
    Job.find(params[:id]).destroy
    redirect '/jobs'
    #success or failure of destroy message
  end
  
  helpers do 
    def current_user
      User.find(session[:id])
    end
    
    def logged_in?
      !!session[:id]
    end
  end

  
end