require 'sinatra'
require 'json'
require_relative 'my_user_model'

enable :sessions

user = User.new

get '/users' do
  content_type :json
  user.all.to_json
end

post '/users' do
  content_type :json
  user_info = {
    firstname: params[:firstname],
    lastname: params[:lastname],
    age: params[:age].to_i,
    password: params[:password],
    email: params[:email]
  }
  user_id = user.create(user_info)
  user.find(user_id).to_json
end

post '/sign_in' do
  content_type :json
  user_info = user.all.find { |_id, data| data[:email] == params[:email] && data[:password] == params[:password] }
  if user_info
    session[:user_id] = user_info.first
    user_info.last.to_json
  else
    status 401
  end
end

put '/users' do
  content_type :json
  unless session[:user_id]
    status 401
    return
  end
  user.update(session[:user_id], "password", params[:password])
  user.find(session[:user_id]).to_json
end

delete '/sign_out' do
  session.clear
  status 204
end

delete '/users' do
  content_type :json
  unless session[:user_id]
    status 401
    return
  end
  user.destroy(session[:user_id])
  session.clear
  status 204
end

get '/' do
  erb :index
end