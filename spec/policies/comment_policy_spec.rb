require 'spec_helper'

describe Storytime::CommentPolicy do
  subject { Storytime::CommentPolicy.new(user, comment) }
  let(:site) { FactoryGirl.create(:site) }
  let(:post) { FactoryGirl.create(:post) }

  context "as a normal user" do
    before do
      Storytime.user_class.any_instance.stub(:current_membership).and_return(nil)
    end

    let(:user) { FactoryGirl.create(:user) }

    context "a comment owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, user: user, post: post, site: site) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end


    context "a comment not owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, post: post, site: site) }

      it { should_not permit!(:create)  }
      it { should_not permit!(:destroy)  }
    end
  end

  context "as an editor" do
    before do
      Storytime.user_class.any_instance.stub(:current_membership).and_return(user.storytime_memberships.first)
    end

    let(:user){ FactoryGirl.create(:editor) }

    context "a comment owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, user: user, post: post, site: site) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, post: post, site: site) }

      it { should_not permit!(:create)  }
      it { should permit!(:destroy)  }
    end
  end

  context "as an admin" do
    before do
      Storytime.user_class.any_instance.stub(:current_membership).and_return(user.storytime_memberships.first)
    end
    let(:user){ FactoryGirl.create(:admin) }

    context "a comment owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, user: user, post: post, site: site) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, post: post, site: site) }

      it { should_not permit!(:create)  }
      it { should permit!(:destroy)  }
    end
  end
  
end