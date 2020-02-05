require_relative 'src/Scraper.rb'

scraper = Scraper.new
scraper.run()
scraper.export("output/DatosMarco_v03.csv")