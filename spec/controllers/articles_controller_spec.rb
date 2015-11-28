require 'rails_helper'

def author_sign_in
  @request.env["devise.mapping"] = Devise.mappings[:user]
  user = FactoryGirl.create(:user)
  sign_in user
end

describe ArticlesController do
  
  describe "GET #index" do
    context "with params[:q]" do
      it "redirects to search action" do
        get :index, q: "rails"
        expect(response).to redirect_to(search_articles_url(q: "rails"))
      end  
    end

    context "without params[:q]" do
      it "populates an array of all articles" do
        article1 = create(:article)
        article2 = create(:article)

        get :index 
        expect(assigns(:articles)).to match_array([article1, article2])
      end

      it "renders the :index template" do
        get :index
        expect(response).to render_template(:index)
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested article to @article" do
      article = create(:article)
      get :show, id: article
      expect(assigns(:article)).to eq(article)
    end

    it "renders the :show template" do
      article = create(:article)
      get :show, id: article
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do

    context "when user is not signed in" do
      it "redirects to sign in page" do
        get :new 
        expect(response).to redirect_to new_user_session_url
      end  
    end

    context "when signed in" do

      before :each do
        author_sign_in
      end

      it "assigns a new Article to @article" do
        get :new
        expect(assigns(:article)).to be_a_new(Article)
      end

      it "renders the :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET #edit" do

    context "when user is not signed in" do
      it "redirects to sign in page" do
        article = create(:article)
        get :edit, id: article
        expect(response).to redirect_to new_user_session_url
      end
    end

    context "when signed in" do 

      before :each do
        author_sign_in
      end

      it "assigns the requested article to @article" do
        article = create(:article)
        get :edit, id: article
        expect(assigns(:article)).to eq(article)
      end

      it "renders the :edit template" do
        article = create(:article)
        get :edit, id: article 
        expect(response).to render_template :edit
      end
    end
  end

  describe "POST #create" do

    context "when user is not signed in" do
      it "redirects to sign in page" do
        post :create, article: attributes_for(:article)
        expect(response).to redirect_to new_user_session_url
      end

      it "does not create a new article" do
        expect { post :create, article: attributes_for(:article) }.not_to change(Article, :count)
      end
    end

    context "when signed in" do 

      before :each do
        author_sign_in
      end

      context "with valid attributes" do
        it "saves the new article to the database" do
          expect { post :create, article: attributes_for(:article) }.to change(Article, :count).by(1)
        end

        it "redirects to articles#show" do
          post :create, article: attributes_for(:article)
          expect(response).to redirect_to article_url(assigns(:article))
        end
      end

      context "with invalid attributes" do
        it "does not save the new article in the database" do
          expect { post :create, article: attributes_for(:invalid_article) }.not_to change(Article, :count)
        end
        it "re-renders the :new template" do
          post :create, article: attributes_for(:invalid_article)
          expect(response).to render_template :new
        end
      end
    end
  end

  describe "PATCH #update" do

    before(:each) do
      @article = create(:article, title: "My awesome blog post", content: "some awesome stuff", keywords: "ruby, rails")
    end

    context "when user is not signed in" do
      it "redirects to sign in page" do
        patch :update, id: @article, article: attributes_for(:article)
        expect(response).to redirect_to new_user_session_url
      end

      it "does not update the article" do
        patch :update, id: @article, article: attributes_for(:article, title: "Updated title")
        @article.reload
        expect(@article.title).not_to eq("Updated title")
      end 
    end

    context "when signed in" do 

      before :each do
        author_sign_in
      end

      context "with valid attributes" do

        it "locates the requested article" do
          patch :update, id: @article, article: attributes_for(:article)
          expect(assigns(:article)).to eq(@article)
        end

        it "updates the article in the database" do
          patch :update, id: @article, article: attributes_for(:article, title: "Updated title", content: "Updated content")
          @article.reload
          expect(@article.title).to eq("Updated title")
          expect(@article.content).to eq("Updated content")
        end

        it "redirects to articles#show" do
          patch :update, id: @article, article: attributes_for(:article)
          expect(response).to redirect_to @article
        end
      end


      context "with invalid attributes" do

        it "does not update the article" do
          patch :update, id: @article, article: attributes_for(:article, title: "Updated title", content: nil)
          @article.reload
          expect(@article.title).not_to eq("Updated title")
          expect(@article.content).not_to be_nil
        end 

        it "re-renders the :edit template" do
          patch :update, id: @article, article: attributes_for(:invalid_article)
          expect(response).to render_template :edit
        end
      end
    end
  end

  describe "DELETE #destroy" do

    before :each do
      @article = create(:article)
    end

    context "when user is not signed in" do
      it "redirecs to sign in page" do
        delete :destroy, id: @article
        expect(response).to redirect_to new_user_session_url
      end

      it "does not delete the article" do
        expect { delete :destroy, id: @article }.not_to change(Article, :count)
      end
    end

    context "when signed in" do

      before :each do
        author_sign_in
      end

      it "deletes the contact from the database" do
        expect { delete :destroy, id: @article }.to change(Article, :count).by(-1)
      end

      it "redirects to articles#index" do
        delete :destroy, id: @article 
        expect(response).to redirect_to articles_url
      end
    end
  end

  describe "GET #search" do
    
    before :each do
      @ruby = create(:article, title: "The Ruby Way", content: "Ruby is awesome language", keywords: "ruby, programming, matz")
      @rails = create(:article, title: "The Rails 4 Way", content: "Rails is an awesome framework", keywords: "rails, framework, dhh")
    end

    context "when searched for query word that matches articles" do
      it "populates an array with matching articles" do
        get :search, q: 'ruby'
        expect(assigns(:articles)).to match_array([@ruby])
        expect(assigns(:articles)).not_to include(@rails)
      end

      it "renders the index template" do
        get :search, q: 'ruby'
        expect(response).to render_template :index
      end
    end 

    # Edge case where user manually types in URL search/?q=
    context "when search with an empty query word" do
      it "assings nil to @article" do
        get :search, q: nil
        expect(assigns(:article1)).to be_nil
      end

      it "renders the index tempalte" do
        get :search, q: nil
        expect(response).to render_template :index
      end
    end
  end
end

























