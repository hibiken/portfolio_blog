class AddPublishedToArticles < ActiveRecord::Migration
  def up
    add_column :articles, :published, :boolean, default: false
    Article.find_each do |article|
      article.published = true
      article.save!
    end
  end

  def down
    remove_column :articles, :published
  end
end
