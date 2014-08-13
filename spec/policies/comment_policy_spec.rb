require 'spec_helper'

describe Storytime::CommentPolicy do
  subject { Storytime::CommentPolicy.new(user, comment) }
  let(:post) { FactoryGirl.create(:post) }

  context "as a normal user" do
    let(:user) { FactoryGirl.create(:user) }

    context "a comment owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, user: user, post: post) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, post: post) }

      it { should_not permit!(:create)  }
      it { should_not permit!(:destroy)  }
    end
  end

  context "as an editor" do
    let(:user){ FactoryGirl.create(:editor) }

    context "a comment owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, user: user, post: post) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, post: post) }

      it { should_not permit!(:create)  }
      it { should permit!(:destroy)  }
    end
  end

  context "as an admin" do
    let(:user){ FactoryGirl.create(:admin) }

    context "a comment owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, user: user, post: post) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryGirl.build(:comment, post: post) }

      it { should_not permit!(:create)  }
      it { should permit!(:destroy)  }
    end
  end
  
end