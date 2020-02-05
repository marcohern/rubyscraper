require 'csv'
require_relative 'LosTiemposScraper.rb'
require_relative 'OpinionBoliviaScraper.rb'

class Program

  attr_accessor :source, :results, :duration

  def initialize
    @sources = Array [
      {
        "uri" => "https://www.lostiempos.com",
        "clazz" => Object.const_get('LosTiemposScraper'),
        "records" => 0,
        "duration" => 0
      },
      {
        "uri" => "https://www.opinion.com.bo",
        "clazz" => Object.const_get('OpinionBoliviaScraper'),
        "records" => 0,
        "duration" => 0
      },
    ]
  end

  def run
    @results = Array[]
    timeStart = Time.now
    for zcraper in @sources
      subStart = Time.now
      scraper = zcraper['clazz'].new
      scraper.scrape(zcraper['uri'])
      records = scraper.records
      @results = @results | records
      subEnd = Time.now
      zcraper['records'] = records.length()
      zcraper['duration'] =subEnd - subStart
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
      for source in @sources
        csv << [
          "",
          "",
          source['uri'],
          "Records: #{source['records']}",
          "Duration: #{source['duration']}s"
      ]
      end
      csv << ["Total Records: #{results.length()}", "Total Duration: #{duration}s" ]
    end
  end
end
