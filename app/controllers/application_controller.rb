require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, Proc.new { File.join(root, "../views/") }
    enable :sessions
    set :session_secret, "password_security"
  end

  get '/' do 
    erb :index
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
    if user && user.authenticate(params[:password])
      session[:id] = user.id
      redirect "/jobs"
    else
      redirect "/users/login"
    end
  end
  
  get '/users/logout' do
    session.clear
    redirect '/'
    #is there a point in a conditional to see if logged in and who the current user is?
  end

  delete '/users/:id/delete' do #admin function also
    if logged_in?
      user = current_user
      if user.id == params[:id]
        user.destroy
        redirect '/'
      else
        session.clear
        redirect '/users/login'
        #this should probably just be an error.  trying to destroy a user when they are not logged in as user
        #could clear session and then redirect to login
      end
    else
      redirect '/users/login'
    end
  end

  post '/users' do 
    @user = User.new(name: params[:name], username: params[:username], email: params[:email], password: params[:password])
    @user.save
    session[:id] = @user.id
    erb :"/users/show"
  end

  get '/users/:id' do
    if logged_in?
      @user = current_user
      erb :"/users/show"
    else
      redirect '/users/login'
    end
  end

  ###needs to go away in "production"
  get '/users' do    #usefull to have to look at them, but will likely delete later
    if logged_in?
      @users = User.all
      erb :"/users/index"
    else
      redirect '/users/login'
    end
  end
  #suppose this could be an admin view

  get '/users/:id/edit' do
    if logged_in?
      @user = User.find(session[:id])
      erb :"/users/edit"
    else
      redirect '/users/login'
    end
  end

  patch '/users/:id' do #flash mesage for changes saved or not
    user = User.find(params[:id])
    user.update(name: params[:name], username: params[:username], email: params[:email])
    redirect "/users/#{user.id}"
  end

  get '/jobs' do
    if logged_in?
      @jobs = User.find(current_user.id).jobs
      erb :"/jobs/index"
    else
      redirect '/users/login'
    end
  end

  get '/jobs/new' do
    if logged_in?
      erb :"/jobs/new"
    else
      redirect '/users/login'
    end
  end

  post '/jobs' do
    if logged_in?
      user = current_user
      user.jobs.build(title: params[:title], company: params[:company],location: params[:location],salary: params[:salary],body: params[:body],contacts: params[:contacts],company_info: params[:company_info]) 
      user.save
      redirect '/jobs'
    else
      redirect '/users/login'
    end
  end

  get '/jobs/:id' do
    if logged_in?
      @jobs = User.find(current_user.id).jobs
      @job = @jobs.find(params[:id])
      erb :"/jobs/show"
    else
      redirect '/users/login'
    end
  end

  get '/jobs/:id/edit' do
    if logged_in?
      @jobs = User.find(current_user.id).jobs
      @job = @jobs.find(params[:id])
      erb :"/jobs/edit"
    else
      redirect '/users/login'
    end
  end

  patch '/jobs/:id' do
    @job = Job.find(params[:id])
    if logged_in? && current_user.id == @job.user_id 
      @job.update(title: params[:title], company: params[:company],location: params[:location],salary: params[:salary],body: params[:body],contacts: params[:contacts],company_info: params[:company_info])
      erb :"/jobs/show"
    else
      redirct '/users/login'
    end
  end
  
  delete '/jobs/:id/delete' do
    job = Job.find(params[:id])
    if logged_in? && current_user.id == job.user_id
      job.destroy
      redirect '/jobs'
      #success message
    else
      redirect '/users/login'
    end
    #failure message
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