# SYNTAX FROM http://thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/ (modified custom matcher name to permit! due to conflict with Pundit built-in matchers)

require 'spec_helper'

describe Storytime::PagePolicy do
  subject { Storytime::PagePolicy.new(user, page) }

  let(:page) { FactoryGirl.create(:page) }

  context "for a writer" do    
    let(:user) { FactoryGirl.create(:writer) }
    
    context "who owns the page" do
      let(:user) { user = FactoryGirl.create(:writer) }
      let(:page) { page = FactoryGirl.create(:page, user: user) }

      it { should permit!(:index)   }
      it { should permit!(:new)     }
      it { should permit!(:create)  }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the page" do
      it { should     permit!(:index)   }
      it { should_not permit!(:new)     }
      it { should_not permit!(:create)  }
      it { should_not permit!(:manage)  } # edit, update, destroy
      it { should_not permit!(:publish) }
    end
  end

  context "for an editor" do    
    let(:user) { FactoryGirl.create(:editor) }
    
    context "who owns the page" do
      let(:user) { user = FactoryGirl.create(:editor) }
      let(:page) { page = FactoryGirl.create(:page, user: user) }

      it { should permit!(:index)   }
      it { should permit!(:new)     }
      it { should permit!(:create)  }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the page" do
      it { should     permit!(:index)   }
      it { should     permit!(:manage)  } # edit, update, destroy
      it { should     permit!(:publish) }
      it { should_not permit!(:new)     }
      it { should_not permit!(:create)  }
    end
  end

  context "for an admin" do    
    let(:user) { FactoryGirl.create(:admin) }
    
    context "who owns the page" do
      let(:user) { user = FactoryGirl.create(:admin) }
      let(:page) { page = FactoryGirl.create(:page, user: user) }

      it { should permit!(:index)   }
      it { should permit!(:new)     }
      it { should permit!(:create)  }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the page" do
      it { should     permit!(:index)   }
      it { should     permit!(:manage)  } # edit, update, destroy
      it { should     permit!(:publish) }
      it { should_not permit!(:new)     }
      it { should_not permit!(:create)  }
    end
  end
end