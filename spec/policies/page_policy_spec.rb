# SYNTAX FROM http://thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/ (modified custom matcher name to permit! due to conflict with Pundit built-in matchers)

require 'spec_helper'

describe Storytime::PagePolicy do
  subject { Storytime::PagePolicy.new(user, page) }

  context "for a writer" do
    before{ Storytime::User.any_instance.stub(:assign_first_admin).and_return(true) }
    let(:user) { FactoryGirl.create(:writer) }

    context "creating a new page" do
      let(:page) { FactoryGirl.build(:page, user: user) }

      it { should permit!(:new)     }
      it { should permit!(:create)  }
    end
    
    context "who owns the page" do
      let(:page) { FactoryGirl.build_stubbed :page, user: user }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the page" do
      let(:page) { FactoryGirl.build_stubbed :page, user: FactoryGirl.build(:user) }

      it { should     permit!(:index)   }
      it { should_not permit!(:manage)  } # edit, update, destroy
      it { should_not permit!(:publish) }
    end
  end

  context "for an editor" do    
    let(:user) { FactoryGirl.create(:editor) }

    context "creating a new page" do
      let(:page) { FactoryGirl.build(:page, user: user) }

      it { should permit!(:new)     }
      it { should permit!(:create)  }
    end
    
    context "who owns the page" do
      let(:page) { FactoryGirl.build_stubbed :page, user: user }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the page" do
      let(:page) { FactoryGirl.build_stubbed :page, user: FactoryGirl.build(:user) }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
  end

  context "for an admin" do    
    let(:user) { FactoryGirl.create(:admin) }

    context "creating a new page" do
      let(:page) { FactoryGirl.build(:page, user: user) }

      it { should permit!(:new)     }
      it { should permit!(:create)  }
    end
    
    context "who owns the page" do
      let(:page) { FactoryGirl.build_stubbed :page, user: user }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the page" do
      let(:page) { FactoryGirl.build_stubbed :page, user: FactoryGirl.build(:user) }

      it { should permit!(:index)   }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
  end
end