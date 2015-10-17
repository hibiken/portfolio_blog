class ArticlesController < ApplicationController
  before_action :get_article, only: [:show, :edit, :update, :destroy]

  def index
  end

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      flash[:success] = "Sweet! Created a new article!!"
      redirect_to @article
    else
      flash[:danger] = "Something went wrong..."
      render :new
    end
  end

  def edit
  end

  def update
    if @article.update_attributes(article_params)
      flash[:success] = "Nice! Updated the article successfully"
      redirect_to @article
    else
      render :edit
    end
  end

  def destroy
    @article.destroy
    redirect_to posts_url
  end

  private 

    def get_article
      @article = Article.find(params[:id])
    end

    def article_params 
      params.require(:article).permit(:title, :content)
    end
end
