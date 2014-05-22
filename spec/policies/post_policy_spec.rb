# SYNTAX FROM http://thunderboltlabs.com/blog/2013/03/27/testing-pundit-policies-with-rspec/ (modified custom matcher name to permit! due to conflict with Pundit built-in matchers)

require 'spec_helper'

describe Storytime::PostPolicy do
  subject { Storytime::PostPolicy.new(user, post) }

  let(:post) { FactoryGirl.create(:post) }

  context "for a writer" do    
    let(:user) { FactoryGirl.create(:writer) }
    
    context "who owns the post" do
      let(:user) { user = FactoryGirl.create(:writer) }
      let(:post) { post = FactoryGirl.create(:post, user: user) }

      it { should permit!(:index)   }
      it { should permit!(:new)     }
      it { should permit!(:create)  }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the post" do
      it { should     permit!(:index)   }
      it { should_not permit!(:new)     }
      it { should_not permit!(:create)  }
      it { should_not permit!(:manage)  } # edit, update, destroy
      it { should_not permit!(:publish) }
    end
  end

  context "for an editor" do    
    let(:user) { FactoryGirl.create(:editor) }
    
    context "who owns the post" do
      let(:user) { user = FactoryGirl.create(:editor) }
      let(:post) { post = FactoryGirl.create(:post, user: user) }

      it { should permit!(:index)   }
      it { should permit!(:new)     }
      it { should permit!(:create)  }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the post" do
      it { should     permit!(:index)   }
      it { should     permit!(:manage)  } # edit, update, destroy
      it { should     permit!(:publish) }
      it { should_not permit!(:new)     }
      it { should_not permit!(:create)  }
    end
  end

  context "for an admin" do    
    let(:user) { FactoryGirl.create(:admin) }
    
    context "who owns the post" do
      let(:user) { user = FactoryGirl.create(:admin) }
      let(:post) { post = FactoryGirl.create(:post, user: user) }

      it { should permit!(:index)   }
      it { should permit!(:new)     }
      it { should permit!(:create)  }
      it { should permit!(:manage)  } # edit, update, destroy
      it { should permit!(:publish) }
    end
    
    context "who does not own the post" do
      it { should     permit!(:index)   }
      it { should     permit!(:manage)  } # edit, update, destroy
      it { should     permit!(:publish) }
      it { should_not permit!(:new)     }
      it { should_not permit!(:create)  }
    end
  end
end