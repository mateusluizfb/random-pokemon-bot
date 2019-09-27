require "mechanize"
require "twitter"
require "open-uri"

page = Mechanize.new
       .get('https://pokemon.alexonsager.net/')
       .search('div#wrapper')
       .search('div#main')
       .search('div#fused')

pokemon_name = page.search('div.title').search('div#pk_name').children.last.to_s
pokemon_image_url = page.search('img').last.values.last

File.open('pokemon_image.png', 'wb') {|fo| fo.write open(pokemon_image_url).read }

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ""
  config.consumer_secret     = ""
  config.access_token        = ""
  config.access_token_secret = ""
end

File.open('pokemon_image.png', 'r'){|f| client.update_with_media("Pokemon of the day: #{pokemon_name}", f) }
