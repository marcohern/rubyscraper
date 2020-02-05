require 'csv'
require_relative 'LosTiemposScraper.rb'
require_relative 'OpinionBoliviaScraper.rb'

class Program

  attr_accessor :source, :results, :duration

  def initialize
    @source = Array [
      {
        "uri" => "https://www.lostiempos.com",
        "clazz" => Object.const_get('LosTiemposScraper')
      },
      {
        "uri" => "https://www.opinion.com.bo",
        "clazz" => Object.const_get('OpinionBoliviaScraper')
      },
    ]
  end

  def run
    @results = Array[]
    timeStart = Time.now
    for zcraper in @source
      puts "Scraping #{zcraper['uri']}"
      scraper = zcraper['clazz'].new
      scraper.scrape(zcraper['uri'])
      records = scraper.records
      @results = @results | records
    end
    timeEnd = Time.now
    @duration = timeEnd - timeStart
  end

  def export(filename)
    n = 1
    CSV.open(filename, "wb") do |csv|
      csv << ["#", "MD5", "Domain", "Url", "Title", "Date", "Place", "Body", "Image"]
      for article in @results
        csv << [n, article.md5, article.domain, article.uri, article.title, article.date, article.category, article.body, article.image]
        n = n + 1
      end
      csv << ["Records: #{results.length()}", "Duration: #{duration}s" ]
    end
  end
end
