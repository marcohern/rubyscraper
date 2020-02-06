require 'HTTParty'
require 'Nokogiri'
require_relative 'Article.rb'
require_relative 'BaseScrapeStrategy.rb'

class OpinionBoliviaScrapeStrategy < BaseScrapeStrategy

  def scrapeRecord(container)
    if container.css('.guia-medica').length() > 0
      return nil
    end
    article = Article.new
    found = scrapeTitleAndUrl(container, article)
    if found
      scrapeDataImage(container, article)
      scrapeBody(@uri + article.uri, article)
      return article
    end
    return nil
  end

  def scrapeDataImage(container, article)
    imgElement = container.css('img')
    if imgElement.length() > 0
      if imgElement[0].key?('data-src')
        article.image = imgElement[0]['data-src']
      end 
    end
  end

  def scrapeTitleAndUrl(container, article)
    titleElement = container.css('.title a, .data-title a')
    if titleElement.length() > 0
      article.title = titleElement.text.tr("\n","").strip()
      article.uri = titleElement[0]['href']
      return true
    end
    return false
  end

  def scrapeBody(uri, article)
    page = getContent(uri)
    article.body = page.css('.body').text.tr("\n","").strip()[0..100]+"..."
    article.date = page.css('.content-time').text.tr("\n","").strip()
  end
end