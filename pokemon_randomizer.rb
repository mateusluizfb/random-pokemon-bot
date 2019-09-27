require "mechanize"

page = Mechanize.new
       .get('https://pokemon.alexonsager.net/')
       .search('div#wrapper')
       .search('div#main')
       .search('div#fused')

pokemon_name = page.search('div.title').search('div#pk_name').children.last.to_s
pokemon_image_url = page.search('img').last.values.last
