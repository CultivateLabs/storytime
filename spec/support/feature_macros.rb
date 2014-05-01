module FeatureMacros
  def login(user = nil)
    user ||= FactoryGirl.create(:user)
    visit new_user_session_path
    
    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    
    click_on "Sign in"
    page.should have_content("Signed in successfully.")
    @current_user = user
  end
  
  def current_user
    @current_user
  end
end
