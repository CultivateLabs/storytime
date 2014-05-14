require 'test_helper'

module Storytime
  class SitesControllerTest < ActionController::TestCase
    setup do
      @site = sites(:one)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:sites)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create site" do
      assert_difference('Site.count') do
        post :create, site: { footer: @site.footer, ga_tracking_id: @site.ga_tracking_id, header: @site.header, post_slug_style: @site.post_slug_style, root_page_content: @site.root_page_content, title: @site.title }
      end

      assert_redirected_to site_path(assigns(:site))
    end

    test "should show site" do
      get :show, id: @site
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @site
      assert_response :success
    end

    test "should update site" do
      patch :update, id: @site, site: { footer: @site.footer, ga_tracking_id: @site.ga_tracking_id, header: @site.header, post_slug_style: @site.post_slug_style, root_page_content: @site.root_page_content, title: @site.title }
      assert_redirected_to site_path(assigns(:site))
    end

    test "should destroy site" do
      assert_difference('Site.count', -1) do
        delete :destroy, id: @site
      end

      assert_redirected_to sites_path
    end
  end
end
