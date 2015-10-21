module ArticlesHelper

  # Returns an array of keywords of a given article.
  def keywords(article)
    article.keywords.split(',').map { |keyword| keyword.strip }
  end
end
