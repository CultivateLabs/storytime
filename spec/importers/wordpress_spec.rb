require 'spec_helper'

describe Storytime::Importers::Wordpress do
  let(:file){ File.open("./spec/support/files/wordpress_export.xml") }
  let(:user){ FactoryGirl.create(:user) }
  let(:importer){ Storytime::Importers::Wordpress.new file, user }

  describe "#import!" do
    it "imports" do
      expect(Storytime::Post.count).to eq(0)
      posts = importer.import!
      expect(Storytime::Post.count).to eq(4)
      
      expect(posts[0].title).to eq("Hello world!")
      expect(posts[0].content).to match("After you read this")
      expect(posts[0].user).to eq(user)
      expect(posts[0].created_at).to eq(Time.strptime("2011-08-16 22:00:35 UTC", "%Y-%m-%d %H:%M:%S %Z"))
      expect(posts[0].published_at).to eq(Time.strptime("Tue, 16 Aug 2011 22:00:35 +0000", "%a, %d %b %Y %H:%M:%S %z"))

      expect(posts[1].title).to eq("this is a test post")
      expect(posts[1].content).to match("this is the content of a test post Bacon ipsum dolor")
      expect(posts[1].user).to eq(user)
      expect(posts[1].created_at).to eq(Time.strptime("2014-07-28 02:42:21 UTC", "%Y-%m-%d %H:%M:%S %Z"))
      expect(posts[1].published_at).to eq(Time.strptime("Mon, 28 Jul 2014 02:42:21 +0000", "%a, %d %b %Y %H:%M:%S %z"))

      expect(posts[2].title).to eq("Another test post")
      expect(posts[2].content).to match("Chicken doner boudin ham, drumstick landjaeger meatball ")
      expect(posts[2].user).to eq(user)
      expect(posts[2].created_at).to eq(Time.strptime("2014-07-28 02:43:07 UTC", "%Y-%m-%d %H:%M:%S %Z"))
      expect(posts[2].published_at).to eq(Time.strptime("Mon, 28 Jul 2014 02:43:07 +0000", "%a, %d %b %Y %H:%M:%S %z"))

      expect(posts[3].title).to eq("this is a draft post")
      expect(posts[3].content).to match("this is the content of a draft post")
      expect(posts[3].user).to eq(user)
      expect(posts[3].created_at.to_date).to eq(Time.now.utc.to_date)
      expect(posts[3].published_at).to be_nil
    end
  end
end