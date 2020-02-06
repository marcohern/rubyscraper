require_relative 'Article.rb'
require_relative 'BaseScrapeStrategy.rb'

class ElEspectadorScrapeStrategy < BaseScrapeStrategy

  def scrapeRecord(container)
    article = Article.new
    titleAndUrlFound = scrapeTitleAndUrl(container, article)
    if titleAndUrlFound
      scrapeImage(container, '.image-container', article)
      scrapeCategoryDate(container, article)
      #scrapeBody(@uri + article.uri, article)
      return article
    end
    return nil
  end

  def scrapeTitleAndUrl(container, article)
    linkElement = container.css('h2 a, h3 a')
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

  def scrapeCategoryDate(container, article)
    ctn = container.css('.category-published')
    categoryElement = ctn.css('.category');
    if (categoryElement.length() > 0)
      article.category = categoryElement.text
    end
    dateElement = ctn.css('.published-at');
    if (dateElement.length() > 0)
      article.date = dateElement.text
    end
  end

  def scrapeBody(article, bodyHtml)
    #article.body = bodyHtml.css('.body p, .content p').text.tr("\n","").strip()[0..100]+"..."
  end
end