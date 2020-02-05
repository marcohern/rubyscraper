require 'HTTParty'
require 'Nokogiri'

require_relative 'Article.rb'

class BaseScrapeStrategy
  attr_accessor :html, :records, :uri, :index

  def initialize(options)
    @records = Array[]
    @index = 0
    @uri = options["uri"]
    @selector = options["selector"]
  end

  def scrape()
    puts "Scraping #{@uri}"
    content = HTTParty.get(@uri);
    @html = Nokogiri::HTML(content.body, nil, Encoding::UTF_8.to_s)
    scrapeRecords()
  end

  def scrapeRecords()
    elements = @html.css(@selector)
    elements.map do |container|
      article = scrapeRecord(container)
      @index = @index+1
      if !article.nil?
        article.domain = @uri
        @records.push(article)
      end
    end
  end

  def scrapeImage(container, selector, article=nil)
    imgElement = container.css(selector + ' img')
    if imgElement.length() > 0
      article.image = imgElement[0]['src'] 
    end
  end

  def scrapeRecord(container)
    return nil
  end

  def scrapeSingle(container, selector, attributes)
    result = {
      "foo" => "asas"
    }
    element = container.css(selector)
    if element.length() > 0
      if element.length() == 1
        element[0].text
      end
    end
  end
end