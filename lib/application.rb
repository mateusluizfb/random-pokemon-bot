# frozen_string_literal: true

require 'mechanize'
require 'twitter'
require 'open-uri'

module Application
  IMAGE_FILE_NAME = 'pokemon_image.png'

  def self.generate_pokemon
    div = find_pokemon_info_div
    pokemon_name = pokemon_name(div)
    image_url = pokemon_image_url(div)
    pokemon_image_file = download_image(image_url)
    send_tweet(pokemon_name, pokemon_image_file)
  end

  def self.find_pokemon_info_div
    Mechanize.new
             .get('https://pokemon.alexonsager.net/')
             .search('div#wrapper')
             .search('div#main')
             .search('div#fused')
  end

  def self.pokemon_name(page)
    page.search('div.title').search('div#pk_name').children.last.to_s
  end

  def self.pokemon_image_url(page)
    page.search('img').last.values.last
  end

  def self.download_image(image_url)
    file = File.open(IMAGE_FILE_NAME, 'w+')
    file.write open(image_url).read
    file.close
    File.open(IMAGE_FILE_NAME, 'r')
  end

  def self.send_tweet(pokemon_name, pokemon_image_file)
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['CONSUMER_KEY']
      config.consumer_secret     = ENV['CONSUMER_SECRET']
      config.access_token        = ENV['ACCESS_TOKEN']
      config.access_token_secret = ENV['ACCESS_TOKEN_SECRET']
    end

    client.update_with_media("Pokemon of the day: #{pokemon_name} #pokemon", pokemon_image_file)
  end
end
