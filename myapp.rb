# myapp.rb
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sequel'
require 'logger'

set :show_exceptions, false

# connect to an in-memory database
DB = Sequel.sqlite
DB.loggers << Logger.new($stdout)

# create an items table
DB.create_table :items do
  primary_key :id
  String :name, unique: true, null: false
  Float :price, null: false
end

# create a dataset from the items table
items = DB[:items]

# populate the table
items.insert(name: 'abc', price: rand * 100)
items.insert(name: 'def', price: rand * 100)
items.insert(name: 'ghi', price: rand * 100)

# print out the total price 
puts "The total price is: #{items.sum(:price)}"

get '/' do
  erb :index, :locals => {:items => items}
end

post '/' do
  name = params[:name]
  price = params[:price]
  
  items.insert(name: name, price: price)
  redirect '/'
end

delete '/:id' do
  id = params[:id]
  # p id

  items.where(id: id).delete
  redirect '/'
end

error do
  p env['sinatra.error']
  "ERROR #{env['sinatra.error'].message}"
end

not_found do
  'Page not found'
  redirect '/'
end



