class ArticlesController < ApplicationController
  before_action :get_article, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :check_for_query, only: :index

  def index
    @articles = Article.published.paginate(page: params[:page])
  end

  def search
    @articles = Article.fulltext_search(params[:q]).paginate(page: params[:page])
    render :index
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
    redirect_to articles_url
  end

  def drafts
    @articles = Article.drafts.paginate(page: params[:page])
    render :index
  end


  private 

    def get_article
      @article = Article.friendly.find(params[:id])
    end

    def article_params 
      params.require(:article).permit(:title, :content, :keywords, :slug, :published)
    end

    def check_for_query
      redirect_to search_articles_url(q: params[:q]) if params[:q].present?
    end

end
