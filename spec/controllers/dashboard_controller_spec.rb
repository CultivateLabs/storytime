require 'spec_helper'

describe Storytime::DashboardController do
  context "for actions of subclasses" do
    class WidgetsController < Storytime::DashboardController; end

    controller(WidgetsController) do
      def index; end
    end
    
    it "requires login" do
      get :index
      flash[:alert].should == I18n.t('devise.failure.unauthenticated')
      expect(response).to redirect_to(new_user_session_path)
    end

    it "requires authorization" do
      controller.view_paths.unshift(ActionView::FixtureResolver.new("widgets/index.html.erb" => ""))
      FactoryGirl.create(:site)
      sign_in FactoryGirl.create(:user)
      expect{ get :index }.to raise_error(Pundit::AuthorizationNotPerformedError)
    end

    it "redirects to site setup if none exists" do
      sign_in FactoryGirl.create(:user)
      get :index
      response.should redirect_to(new_dashboard_site_path)
    end
  end
end