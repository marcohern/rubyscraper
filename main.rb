require_relative 'src/Scraper.rb'

sources = Array [
  {
    "uri" => "https://www.lostiempos.com",
    "strategy" => 'LosTiemposScrapeStrategy',
    "selector" => '.views-row, table .col-1, table .col-2, table .col-3, table .col-4',
    "records" => 0,
    "duration" => 0
  },
  {
    "uri" => "https://www.opinion.com.bo",
    "strategy" => 'OpinionBoliviaScrapeStrategy',
    "selector" => 'article, .more-news-section-links li',
    "records" => 0,
    "duration" => 0
  },
]

scraper = Scraper.new
scraper.scrape(sources)
scraper.export("output/DatosMarco_v03.csv")