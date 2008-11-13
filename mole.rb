#!/usr/bin/env ruby

require 'rubygems'
require 'sinatra'

Dir["lib/*.rb"].each { |x| load x }

configure do
  set_option :sessions, true
end

before do
  if (!logged_in? or !current_user) and request.path_info !~ /login/ 
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

post '/login' do
  @email = params[:email]
  if user = User.find_by_email(@email) and user.authenticate?(params[:password])
    session[:user] = user.id
    redirect '/'
  end
  erb :login
end

# -- Clients

get '/clients' do
  @clients = Client.find(:all).reverse
  erb :clients
end

get '/client/:client_id' do
  @client = Client.find(params[:client_id])
  @projects = @client.projects
  erb :client
end

post '/client' do
  client = Client.create!(
    :name => params[:name],
    :image_url => params[:image_url]
  )
  redirect "/client/#{client.id}"
end

get '/client/:client_id/destroy' do
  Client.find(params[:client_id]).destroy
  redirect '/clients'
end

# -- Projects

get '/project/:project_id' do
  @project = Project.find(params[:project_id])
  erb :project
end

post '/project' do
  project = Project.create!(:name => params[:name], :client_id => params[:client_id])
  redirect "/client/#{project.client.id}"
end

get '/project/:project_id/destroy' do
  project = Project.find(params[:project_id])
  client = project.client
  project.destroy
  redirect "/client/#{client.id}"
end

# -- Entries

post '/entry' do
  Entry.create!(
    :user => current_user, 
    :project_id => params[:project],
    :hours => params[:hours],
    :message => params[:message]
  )
  redirect '/'
end

# -- People

get '/people' do
  @people = Contact.find(:all).reverse
  erb :people
end

post '/person' do
  contact = Contact.create!(
    :client_id => params[:client_id],
    :name => params[:name],
    :telephone => params[:telephone],
    :image_url => params[:image_url]
  )
  redirect "/client/#{contact.client.id}"
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
  User.find(params[:user_id]).destroy unless current_user.id == params[:user_id].to_i
  redirect '/admin'
end
