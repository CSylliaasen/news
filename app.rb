require "sinatra"
require "sinatra/reloader"
require "geocoder"
require "forecast_io"
require "httparty"
def view(template); erb template.to_sym; end
before { puts "Parameters: #{params}" }                                     

ForecastIO.api_key = "ed42ff947d4dbc52dfd22cf04f3a5627"

get "/" do
    @locationSet = false
    view "ask"
end

get "/news" do
    results = Geocoder.search(params["q"])
    @location = results.first.city
    @lat_long = results.first.coordinates # => [lat, long]
    @forecast = ForecastIO.forecast(@lat_long[0],@lat_long[1]).to_hash
    url = "https://newsapi.org/v2/top-headlines?country=#{results.first.country_code}&apiKey=0aa4a46912d945e49daf6aad7e887036"
    @news = HTTParty.get(url).parsed_response.to_hash
    @locationSet = true
    view "ask"
end