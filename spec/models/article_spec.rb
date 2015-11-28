require 'rails_helper'

describe Article do
  it "is valid with title, content, and keywords" do
    expect(build(:article)).to be_valid
  end

  it "is invalid with invalid factory" do
    expect(build(:invalid_article)).not_to be_valid
  end

  it "is invalid without title" do
    article = build(:article, title: nil)
    article.valid?
    expect(article.errors[:title]).to include("can't be blank")
  end

  it "is invalid without content" do
    article = build(:article, content: nil)
    article.valid?
    expect(article.errors[:content]).to include("can't be blank")
  end

  it "is invalid without keywords" do
    article = build(:article, keywords: nil)
    article.valid?
    expect(article.errors[:keywords]).to include("can't be blank")
  end
 
  it "is invalid with a duplicate title" do
    create(:article, title: "Awesome Stuff")

    article = build(:article, title: "Awesome Stuff")
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