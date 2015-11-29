require 'rails_helper'

feature "Creating an article" do
  
  background do
    @user = create(:user)
    visit new_user_session_url
    fill_in "Email", with: @user.email 
    fill_in "Password", with: @user.password 
    click_button "Log in"
  end

  scenario "adds an article" do
    visit new_article_url


    expect {
      fill_in "Title", with: "Ruby on Rails is Awesome"
      fill_in "Write your article here", with: Faker::Lorem.paragraph
      fill_in "Enter keywords", with: "ruby, rails, framework"
      click_button "Save"
      }.to change(Article, :count).by(1)

    expect(current_path).to eq article_path(Article.last)
  end
end