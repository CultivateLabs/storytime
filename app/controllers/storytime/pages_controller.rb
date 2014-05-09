require_dependency "storytime/application_controller"

module Storytime
  class PagesController < ApplicationController
    def show
      @page = Page.find(params[:id])
    end
  end
end