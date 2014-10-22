require "spec_helper"

describe "Root path" do
  it "routes to posts#index when site#root_page_content is posts" do
    FactoryGirl.create(:site, root_page_content: :posts)
    get "/"
    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("index")
  end

  it "routes to pages#show when site#root_page_content is page" do
    home_page = FactoryGirl.create(:page)
    FactoryGirl.create(:site, root_page_content: :page, root_post_id: home_page.id)
    get "/"
    expect(request.params[:controller]).to eq("storytime/pages")
    expect(request.params[:action]).to eq("show")
    expect(response.body).to match(home_page.title)
  end
end

describe "Post path" do
  it "uses /posts/post-slug when site#post_slug_style is default" do
    FactoryGirl.create(:site, post_slug_style: :default)
    post = FactoryGirl.create(:post)
    expect(url_for([post, only_path: true])).to  eq("/posts/#{post.slug}")

    get url_for([post, only_path: true])
    
    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.slug)
  end

  it "uses /year/month/day/post-slug when site#post_slug_style is day_and_name" do
    FactoryGirl.create(:site, post_slug_style: :day_and_name)
    post = FactoryGirl.create(:post)
    date = post.created_at.to_date
    expect(url_for([post, only_path: true])).to  eq("/#{date.year}/#{date.strftime('%m')}/#{date.strftime('%d')}/#{post.slug}")

    get url_for([post, only_path: true])
    
    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.slug)
  end

  it "uses /year/month/post-slug when site#post_slug_style is month_and_name" do
    FactoryGirl.create(:site, post_slug_style: :month_and_name)
    post = FactoryGirl.create(:post)
    date = post.created_at.to_date
    expect(url_for([post, only_path: true])).to  eq("/#{date.year}/#{date.strftime('%m')}/#{post.slug}")

    get url_for([post, only_path: true])
    
    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.slug)
  end

  it "uses /post-id when site#post_slug_style is post_id" do
    FactoryGirl.create(:site, post_slug_style: :post_id)
    post = FactoryGirl.create(:post)
    expect(url_for([post, only_path: true])).to eq("/posts/#{post.id}")

    get url_for([post, only_path: true])
    
    expect(request.params[:controller]).to eq("storytime/posts")
    expect(request.params[:action]).to eq("show")
    expect(request.params[:id]).to eq(post.id.to_s)
  end
end
