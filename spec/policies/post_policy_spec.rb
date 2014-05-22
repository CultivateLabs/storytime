# SYNTAX FROM http://thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/ (modified custom matcher name to permit! due to conflict with Pundit built-in matchers)

require 'spec_helper'

describe Storytime::PostPolicy do
  subject { Storytime::PostPolicy.new(user, post) }

  context "for a writer" do    
    let(:user) { FactoryGirl.create(:writer) }

    context "creating a new post" do
      let(:post) { FactoryGirl.build(:post, user: user) }

      it { should permit!(:new)     }
      it { should permit!(:create)  }
    end
    
    context "who owns the post" do
      let(:post) { FactoryGirl.build_stubbed :post, user: user }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the post" do
      let(:post) { FactoryGirl.build_stubbed :post, user: FactoryGirl.build(:user) }

      it { should     permit!(:index)   }
      it { should_not permit!(:manage)  } # edit, update, destroy
      it { should_not permit!(:publish) }
    end
  end

  context "for an editor" do    
    let(:user) { FactoryGirl.create(:editor) }

    context "creating a new post" do
      let(:post) { FactoryGirl.build(:post, user: user) }

      it { should permit!(:new)     }
      it { should permit!(:create)  }
    end
    
    context "who owns the post" do
      let(:post) { FactoryGirl.build_stubbed :post, user: user }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the post" do
      let(:post) { FactoryGirl.build_stubbed :post, user: FactoryGirl.build(:user) }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
  end

  context "for an admin" do    
    let(:user) { FactoryGirl.create(:admin) }

    context "creating a new post" do
      let(:post) { FactoryGirl.build(:post, user: user) }

      it { should permit!(:new)     }
      it { should permit!(:create)  }
    end
    
    context "who owns the post" do
      let(:post) { FactoryGirl.build_stubbed :post, user: user }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the post" do
      let(:post) { FactoryGirl.build_stubbed :post, user: FactoryGirl.build(:user) }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
  end
end