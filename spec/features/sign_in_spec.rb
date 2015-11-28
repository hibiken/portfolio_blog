require 'rails_helper'

feature "Sign in" do
  
  background do
    @user = create(:user)
  end

  scenario 'logs in a user' do
    visit new_user_session_url

    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Log in"

    expect(current_path).to eq(root_path)
  end
end