module Storytime
  module Dashboard
    module AutosavesHelper
      def autosave_info(autosavable)
        render 'storytime/dashboard/autosaves/autosave_info', autosavable: autosavable
      end
    end
  end
end