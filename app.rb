require "sinatra"
require "sinatra/reloader"

get("/") do
  "
  <h1>Welcome to your Sinatra App!</h1>
  <p>Define some routes in app.rb</p>
  "
end

get("/umbrella") do
  erb(:umbrella_form)
end

get("/process_umbrella") do
  erb(:umbrella_results)
