require "sinatra"
require "sinatra/reloader"
require "http"
require "sinatra/cookies"

get("/") do
  "
  <h1>Welcome to Omnicalc 3</h1>
  "
end

get("/umbrella") do
  erb(:umbrella_form)
end

post("/process_umbrella") do
  @user_location = params.fetch("user_location")
  url_encoded_string = @user_location.gsub(" ", "+")
  gmaps_api_key = ENV.fetch("GMAPS_KEY")
  gmaps_url = "https://maps.googleapis.com/maps/api/geocode/json?address=#{url_encoded_string}&key=#{gmaps_api_key}"
  gmaps_raw = HTTP.get(gmaps_url)
  gmaps_parsed = JSON.parse(gmaps_raw)
    if gmaps_parsed['status'] == 'OK'
      lat_lng = gmaps_parsed['results'][0]['geometry']['location']
      @latitude = lat_lng['lat']
      @longitude = lat_lng['lng']
      cookies["last_location"] = @user_location
      cookies["last_lat"] = @latitude
      cookies["last_lng"] = @longitude
    else
      puts "Sorry, we can't get your location coordinates at the moment. Try later."
      exit
    end
  pirate_api_key = ENV.fetch("PIRATE_WEATHER_KEY")
  pirate_url = "https://api.pirateweather.net/forecast/#{pirate_api_key}/#{latitude},#{longitude}"
  pirate_raw = HTTP.get(pirate_url)
  pirate_parsed = JSON.parse(pirate_raw)
    if pirate_parsed.key?('hourly')
      hourly_forecast = pirate_parsed['hourly']['data']
    else
      puts "Sorry, we can't get the weather at your location right now. Try later."
      exit
    end
  erb(:umbrella_results)
end
