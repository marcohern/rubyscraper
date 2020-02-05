require 'HTTParty'
require 'Nokogiri'

require_relative 'Article.rb'

class Scraper
  attr_accessor :html, :records, :uri, :index

  def initialize
    @records = Array[]
    @index = 0
  end

  def scrapeContent(uri, selector)
    @uri = uri
    content = HTTParty.get(uri);
    @html = Nokogiri::HTML(content, nil, Encoding::UTF_8.to_s)
    scrapeRecords(selector)
  end

  def scrapeRecords(selector)
    elements = @html.css(selector)
    elements.map do |container|
      article = scrapeRecord(container)
      @index = @index+1
      if !article.nil?
        article.domain = @uri
        @records.push(article)
      end
    end
  end

  def scrapeImage(container, selector, article)
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