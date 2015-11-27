require 'rails_helper'

describe Article do
  it "is valid with title, content, and keywords" do
    article = Article.new(title: 'Awesome Stuff', content: 'some awesome content', keywords: 'stuff, awesome')
    expect(article).to be_valid
  end

  it "is invalid without title" do
    article = Article.new(title: '')
    article.valid?
    expect(article.errors[:title]).to include("can't be blank")
  end

  it "is invalid without content" do
    article = Article.new(content: '   ')
    article.valid?
    expect(article.errors[:content]).to include("can't be blank")
  end

  it "is invalid without keywords" do
    article = Article.new(keywords: nil)
    article.valid?
    expect(article.errors[:keywords]).to include("can't be blank")
  end
 
  it "is invalid with a duplicate title" do
    Article.create!(title: 'Awesome Stuff', content: 'some awesome content', keywords: 'stuff, awesome')

    article = Article.new(title: 'Awesome Stuff', content: 'different awesome stuff', keywords: 'stuff, cool')
    article.valid?
    expect(article.errors[:title]).to include("has already been taken")
  end

  context "when searched" do

    before do
      @ruby_article = Article.create!(title: "Ruby on Rails is Awesome!", content: 'I love this full stack framework', keywords: 'developement, hobby')
      @php_article = Article.create!(title: "PHP sucks!", content: "I don't like writing a bunch of configuration for PHP", keywords: 'pain, php')
    end
    
    it "returns articles with query word in title" do
      expect(Article.fulltext_search("ruby on rails")).to include(@ruby_article)
      expect(Article.fulltext_search("ruby on rails")).not_to include(@php_article)
    end

    it "returns articles with query words in keywords" do
      expect(Article.fulltext_search("development")).to include(@ruby_article)
      expect(Article.fulltext_search("development")).not_to include(@php_article)
    end

    it "returns articles with query words in content" do
      expect(Article.fulltext_search("full stack")).to include(@ruby_article)
      expect(Article.fulltext_search("full stack")).not_to include(@php_article)
    end

    it "returns an empty array if no match found" do
      expect(Article.fulltext_search("notexist")).to eq([])
    end
  end

end