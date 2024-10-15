module FeatureMacros
  def login(user = nil, skip_site = false)
    user ||= FactoryBot.create(:user)
    unless skip_site
      setup_site(user)
      set_domain(@current_site.custom_domain)
    end
    
    visit Storytime.login_path

    fill_in "user_email", :with => user.email
    fill_in "user_password", :with => user.password
    
    click_on "Log in"

    expect(page).to have_content("Signed in successfully.")
    @current_user = user
  end

  def login_admin(admin = nil)
    login FactoryBot.create(:admin)
  end

  def login_editor(editor = nil)
    login FactoryBot.create(:editor)
  end

  def login_writer(writer = nil)
    login FactoryBot.create(:writer)
  end
  
  def current_user
    @current_user
  end

  def current_site
    @current_site
  end

  def setup_site(user)
    @current_site ||= FactoryBot.create(:site)
    @current_site.save_with_seeds(user)
    @current_site.homepage = @current_site.blogs.first
    @current_site.save
  end

  def have_link_to_post(post)
    have_link(post.title, href: url_for([:edit, :dashboard, post, only_path: true]))
  end

end
