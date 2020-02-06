require 'csv'

class Scraper

  attr_accessor :source, :results, :domainResults, :duration

  def initialize
    @results = Array[]
    @domainResults = Array[]
  end

  def scrape(sources)
    timeStart = Time.now
    for source in sources
      subStart = Time.now

      require_relative source['strategy']+'.rb'
      strategy = Object.const_get(source['strategy']).new(source, @results)
      strategy.scrape()

      subEnd = Time.now

      dr = { 'uri' => source['uri'], 'records' => strategy.counter, 'duration' => subEnd - subStart};
      @domainResults.push(dr)
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
      for dr in @domainResults
        csv << [
          "",
          "",
          dr['uri'],
          "Records: #{dr['records']}",
          "Duration: #{dr['duration']}s"
      ]
      end
      csv << ["Total Records: #{@results.length()}", "Total Duration: #{@duration}s" ]
    end
  end
end
