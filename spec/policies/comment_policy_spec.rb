require 'spec_helper'

describe Storytime::CommentPolicy do
  subject { Storytime::CommentPolicy.new(user, comment) }
  let(:site) { FactoryBot.create(:site) }
  let(:post) { FactoryBot.create(:post) }

  context "as a normal user" do
    before do
      allow_any_instance_of(Storytime.user_class).to receive(:storytime_admin?).and_return(false)
      allow_any_instance_of(Storytime.user_class).to receive(:storytime_editor?).and_return(false)
    end

    let(:user) { FactoryBot.create(:user) }

    context "a comment owned by the user" do
      let(:comment) { FactoryBot.build(:comment, user: user, post: post, site: site) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end


    context "a comment not owned by the user" do
      let(:comment) { FactoryBot.build(:comment, post: post, site: site) }

      it { should_not permit!(:create)  }
      it { should_not permit!(:destroy)  }
    end
  end

  context "as an editor" do
    before do
      allow_any_instance_of(Storytime.user_class).to receive(:storytime_admin?).and_return(false)
      allow_any_instance_of(Storytime.user_class).to receive(:storytime_editor?).and_return(true)
    end

    let(:user){ FactoryBot.create(:editor) }

    context "a comment owned by the user" do
      let(:comment) { FactoryBot.build(:comment, user: user, post: post, site: site) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryBot.build(:comment, post: post, site: site) }

      it { should_not permit!(:create)  }
      it { should permit!(:destroy)  }
    end
  end

  context "as an admin" do
    before do
      allow_any_instance_of(Storytime.user_class).to receive(:storytime_admin?).and_return(true)
      allow_any_instance_of(Storytime.user_class).to receive(:storytime_editor?).and_return(false)
    end
    let(:user){ FactoryBot.create(:admin) }

    context "a comment owned by the user" do
      let(:comment) { FactoryBot.build(:comment, user: user, post: post, site: site) }

      it { should permit!(:create)  }
      it { should permit!(:destroy)  }
    end

    context "a comment not owned by the user" do
      let(:comment) { FactoryBot.build(:comment, post: post, site: site) }

      it { should_not permit!(:create)  }
      it { should permit!(:destroy)  }
    end
  end
  
end