#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

Dir["lib/*.rb"].each { |x| load x }

configure do
  set_option :sessions, true
end

before do
  if !logged_in? and request.path_info !~ /login/ 
    session['forward'] = request.path_info + (request.query_string.blank? ? '' : '?' + request.query_string)
    redirect '/login'
  end
end

helpers do
  include Helpers
end

get '/' do
  @entries = current_user.entries.reverse
  @projects = Project.find(:all)
  erb :home
end

get '/login' do
  erb :login
end

get '/logout' do
  session[:user] = nil
  redirect '/login'
end

post '/new' do
  Entry.create!(
    :user => current_user, 
    :project_id => params[:project],
    :hours => params[:hours],
    :message => params[:message]
  )
  redirect '/'
end

post '/login' do
  @email = params[:email]
  if user = User.find_by_email(@email) and user.authenticate?(params[:password])
    session[:user] = user.id
    redirect '/'
  end
  erb :login
end

# -- Admin actions

get '/admin' do
  @users = User.find(:all)
  @clients = Client.find(:all)
  erb :admin
end

post '/admin/user' do
  User.create!(:email => params[:email], :password => params[:password])
  redirect '/admin'
end

get '/admin/user/:user_id/destroy' do
  User.find(params[:user_id]).destroy
  redirect '/admin'
end

post '/admin/client' do
  Client.create!(
    :name => params[:name],
    :contact_name => params[:contact_name],
    :contact_telephone => params[:contact_telephone]
  )
  redirect '/admin'
end

get '/admin/client/:client_id' do
  @client = Client.find(params[:client_id])
  @projects = @client.projects
  erb :client
end

get '/admin/client/:client_id/destroy' do
  Client.find(params[:client_id]).destroy
  redirect '/admin'
end

post '/admin/project' do
  project = Project.create!(:name => params[:name], :client_id => params[:client_id])
  redirect "/admin/client/#{project.client.id}"
end

get '/admin/project/:project_id/destroy' do
  Project.find(params[:project_id]).destroy
  redirect '/admin'
end
