require 'HTTParty'
require 'Nokogiri'
require_relative 'Article.rb'
require_relative 'Scraper.rb'

class LosTiemposScraper < Scraper

  def scrape(uri)
    scrapeContent(uri,'.views-row, table .col-1, table .col-2, table .col-3, table .col-4')
  end

  def scrapeRecord(container)
    article = Article.new
    titleAndUrlFound = scrapeTitleAndUrl(container, article)
    if titleAndUrlFound
      scrapeImage(container, '.views-field-field-noticia-fotos', article)
      scrapeDate(container, article)
      scrapeCategory(container, article)
      scrapeBody(@uri + article.uri, article)
      return article
    end
    return nil
  end

  def scrapeTitleAndUrl(container, article)
    linkElement = container.css('.views-field-title a')
    if linkElement.length() > 0
      article.title = linkElement[0].text
      article.uri = linkElement[0]['href']
      return true
    end
    return false
  end

  def scrapeDate(container, article)
    dateElement = container.css('.date-display-single');
    article.date = Time.now.strftime("%Y-%m-%dT%H:%M:00-04:00")
    if (dateElement.length() > 0)
      dateDisplay = dateElement.text.strip()
      dateValue = dateElement[0]['content']
      if !dateValue.nil? and !(dateValue=="")
        article.date = dateValue
      elsif !dateDisplay.nil? and !(dateDisplay=="")
        article.date = dateDisplay
      end
    end
  end

  def scrapeCategory(container, article)
    categoryElement = container.css('.views-field-seccion')
    if (categoryElement.length() > 0)
      article.category = categoryElement.text
    end
  end

  def scrapeBody(uri, article)
    content = HTTParty.get(uri)
    page = Nokogiri::HTML(content, nil, Encoding::UTF_8.to_s)
    article.body = page.css('.body p, .content p').text.tr("\n","").strip()[0..100]+"..."
  end
end