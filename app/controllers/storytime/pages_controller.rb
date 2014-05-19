require_dependency "storytime/application_controller"

module Storytime
  class PagesController < ApplicationController
    def show
      @page = Page.published.friendly.find(params[:id])

      if request.path != page_path(@page)
        return redirect_to @page, :status => :moved_permanently
      end
    end
  end
end