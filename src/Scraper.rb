require 'csv'
require_relative 'LosTiemposScrapeStrategy.rb'
require_relative 'OpinionBoliviaScrapeStrategy.rb'

class Scraper

  attr_accessor :source, :results, :duration

  def scrape(sources)
    @results = Array[]
    timeStart = Time.now
    for source in sources
      subStart = Time.now
      scraper = source['class'].new(source)
      scraper.scrape()
      records = scraper.records
      @results = @results | records
      subEnd = Time.now
      source['records'] = records.length()
      source['duration'] =subEnd - subStart
    end
    timeEnd = Time.now
    @duration = timeEnd - timeStart
  end

  def export(filename, sources)
    n = 1
    CSV.open(filename, "wb") do |csv|
      csv << ["#", "MD5", "Domain", "Url", "Title", "Date", "Place", "Body", "Image"]
      for article in @results
        csv << [n, article.md5, article.domain, article.uri, article.title, article.date, article.category, article.body, article.image]
        n = n + 1
      end
      for source in sources
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
