# myapp.rb
require 'sinatra'
require 'json'


get '/c/:id' do |id|
  "Hello world! #{id}"
  {"id" => id,
   "ala" => "Some html string. <i>with formatting</i>"}.to_json
end

get '/' do
  redirect to('index.html')
end
