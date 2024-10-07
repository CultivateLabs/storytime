require 'spec_helper'

describe Storytime::DashboardController, type: :controller do
  context "for actions of subclasses" do
    class WidgetsController < Storytime::DashboardController; end

    controller(WidgetsController) do
      def index; end
    end

    it "requires login" do
      get :index
      expect(flash[:alert]).to eq(I18n.t('devise.failure.unauthenticated'))
      expect(response).to redirect_to(Rails.application.class.routes.url_helpers.new_user_session_path)
    end

    it "requires authorization" do
      controller.view_paths.unshift(ActionView::FixtureResolver.new("widgets/index.html.erb" => ""))
      FactoryBot.create(:site)
      sign_in FactoryBot.create(:writer)
      get :index
      expect(flash[:error]).to eq("You are not authorized to perform this action.")
    end

    it "redirects to site setup if none exists" do
      allow(Storytime::Site).to receive(:count).and_return(0)
      sign_in FactoryBot.create(:writer)
      get :index
      expect(response).to redirect_to(new_dashboard_site_path)
    end
  end
end
