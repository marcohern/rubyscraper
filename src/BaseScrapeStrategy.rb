require 'HTTParty'
require 'Nokogiri'
require 'pry'

require_relative 'Article.rb'

class BaseScrapeStrategy
  attr_accessor :html, :records, :uri, :counter, :scrapeBody, :getContentCounter

  def initialize(options, records=nil)
    @getContentCounter = 0
    if records.nil?
      @records = Array[]
    else
      @records = records
    end
    @counter = 0
    @uri = options["uri"]
    @selector = options["selector"]
    if options.has_key? 'scrapeBody'
      @scrapeBody = options["scrapeBody"] 
    else
      @scrapeBody = false
    end
  end

  def getContent(uri)
    print "#{self.class.name}-#{uri}-"
    content = HTTParty.get(uri);
    puts "#{content.length} bytes";
    # open("output/#{self.class.name}.#{@getContentCounter}.html", "w") { |f|
    #   f.print(content.body)
    # }
    @getContentCounter += 1
    scontent = content.body.gsub(/\0/,"")
    return Nokogiri::HTML(scontent, nil, Encoding::UTF_8.to_s)
  end

  def scrape()
    @html = getContent(@uri)
    scrapeRecords()
  end

  def scrapeRecords()
    elements = @html.css(@selector)
    elements.map do |container|
      article = scrapeRecord(container)
      if !article.nil?
        @counter = @counter + 1
        article.domain = @uri
        if @scrapeBody
          begin
            bodyHtml = getContent(@uri + article.uri)
            scrapeBody(article, bodyHtml)
          rescue
            puts "ERROR!"
          end
        end
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
    raise NotImplementedError.new("You must implement scrapeRecord.")
  end

  def scrapeBody(article, bodyHtml)
    raise NotImplementedError.new("You must implement scrapeBody.")
  end
end