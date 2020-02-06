require_relative 'src/Scraper.rb'

sources = Array [
  {
    "uri" => "https://www.lostiempos.com",
    "strategy" => 'LosTiemposScrapeStrategy',
    "selector" => '.views-row, table .col-1, table .col-2, table .col-3, table .col-4',
    "scrapeBody" => true
  },
  {
    "uri" => "https://www.opinion.com.bo",
    "strategy" => 'OpinionBoliviaScrapeStrategy',
    "selector" => 'article, .more-news-section-links li',
    "scrapeBody" => true
  },
  {
    "uri" => "https://www.elespectador.com/noticias",
    "strategy" => 'ElEspectadorScrapeStrategy',
    "selector" => '.object',
    "scrapeBody" => true
  },
]

scraper = Scraper.new
scraper.scrape(sources)
scraper.export("output/DatosMarco_v04.csv")