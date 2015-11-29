class StaticPagesController < ApplicationController
  def home
    @articles = Article.published.limit(3)
    @projects = Project.order(created_at: :desc).limit(3)
  end
end
