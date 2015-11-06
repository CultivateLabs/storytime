require "spec_helper"

describe "Root path", type: :request do
  it "routes to blog_homepage#show when site homepage is a blog" do
    site = FactoryGirl.create(:site)
    user = FactoryGirl.create(:admin)
    site.save_with_seeds(user)
    site.homepage = site.blogs.first

    get "/"

    expect(request.params[:controller]).to eq("storytime/blog_homepage")
    expect(request.params[:action]).to eq("show")
  end

  it "routes to pages#show when site homepage is page" do
    site = FactoryGirl.create(:site)
    user = FactoryGirl.create(:admin)
    home_page = FactoryGirl.create(:page, site: site)
    site.save_with_seeds(user)
    site.homepage = home_page
    site.save

    get "/"

    expect(request.params[:controller]).to eq("storytime/homepage")
    expect(request.params[:action]).to eq("show")
    expect(response.body).to match(home_page.title)
  end
end

describe "Post path", type: :request do
  it "uses /posts/post-slug when site#post_slug_style is default" do
    site = FactoryGirl.create(:site, post_slug_style: :default, custom_domain: "www.example.com")
    post = FactoryGirl.create(:post, site: site)
    expect(storytime.post_path(post)).to  eq("/posts/#{post.slug}")

    get url_for([post, only_path: true])

    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.slug)
  end

  it "uses /year/month/day/post-slug when site#post_slug_style is day_and_name" do
    site = FactoryGirl.create(:site, post_slug_style: :day_and_name, custom_domain: "www.example.com")
    post = FactoryGirl.create(:post, site: site)
    date = post.created_at.to_date

    expect(url_for([post, only_path: true])).to  eq("/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}")

    get url_for([post, only_path: true])

    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.slug)
  end

  it "uses /year/month/post-slug when site#post_slug_style is month_and_name" do
    site = FactoryGirl.create(:site, post_slug_style: :month_and_name, custom_domain: "www.example.com")
    post = FactoryGirl.create(:post, site: site)
    date = post.created_at.to_date
    expect(url_for([post, only_path: true])).to  eq("/#{date.year}/#{date.strftime('%m')}/#{post.slug}")

    get url_for([post, only_path: true])

    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.slug)
  end

  it "uses /post-id when site#post_slug_style is post_id" do
    site = FactoryGirl.create(:site, post_slug_style: :post_id, custom_domain: "www.example.com")
    post = FactoryGirl.create(:post, site: site)
    expect(url_for([post, only_path: true])).to eq("/posts/#{post.id}")

    get url_for([post, only_path: true])

    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.id.to_s)
  end
end
