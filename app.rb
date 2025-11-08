require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models/user'
require './models/book'

set :database_file, 'config/database.yml'
enable :sessions
set :session_secret, 'this_is_a_very_long_secret_key_for_sessions_at_least_64_chars_long_change_me_in_production'  # Change to random string

helpers do
  def logged_in?
    !!session[:user_id]
  end

  def current_user
    User.find(session[:user_id]) if logged_in?
  end

  def require_login
    unless logged_in?
      flash[:error] = 'You must be logged in to access this page.'
      redirect '/login'
    end
  end
end

get '/' do
  require_login
  @books = Book.all
  erb :index
end

get '/signup' do
  erb :signup
end

post '/signup' do
  user = User.new(username: params[:username], password: params[:password])
  if user.save
    session[:user_id] = user.id
    flash[:success] = 'Signup successful! Welcome.'
    redirect '/'
  else
    flash[:error] = user.errors.full_messages.join(', ')
    redirect '/signup'
  end
end

get '/login' do
  erb :login
end

post '/login' do
  user = User.find_by(username: params[:username])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    flash[:success] = 'Login successful!'
    redirect '/'
  else
    flash[:error] = 'Invalid username or password.'
    redirect '/login'
  end
end

get '/logout' do
  session.clear
  flash[:success] = 'Logout successful!'
  redirect '/login'
end

get '/books/new' do
  require_login
  erb :new
end

post '/books' do
  require_login
  book = Book.new(title: params[:title], author: params[:author], description: params[:description])
  if book.save
    flash[:success] = 'Book created successfully!'
    redirect '/'
  else
    flash[:error] = book.errors.full_messages.join(', ')
    redirect '/books/new'
  end
end

get '/books/:id' do
  require_login
  @book = Book.find(params[:id])
  erb :show
end

get '/books/:id/edit' do
  require_login
  @book = Book.find(params[:id])
  erb :edit
end

post '/books/:id' do
  require_login
  book = Book.find(params[:id])
  book.update(title: params[:title], author: params[:author], description: params[:description])
  if book.save
    flash[:success] = 'Book updated successfully!'
    redirect "/books/#{book.id}"
  else
    flash[:error] = book.errors.full_messages.join(', ')
    redirect "/books/#{book.id}/edit"
  end
end

post '/books/:id/delete' do
  require_login
  book = Book.find(params[:id])
  book.destroy
  flash[:success] = 'Book deleted successfully!'
  redirect '/'
end
