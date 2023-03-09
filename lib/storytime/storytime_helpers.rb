module Storytime
  module StorytimeHelpers
    def storytime_snippet(name)
      snippet = Storytime::Snippet.find_by(name: name, site: current_storytime_site)

      if snippet.nil?
        content = I18n.exists?(name) ? I18n.t(name).html_safe : "Lorem ipsum dolor sit amet, consectetur adipiscing elit..."
        snippet = Storytime::Snippet.create(name: name, content: content, site: current_storytime_site)
      end

      render partial: "storytime/snippets/snippet", locals: {snippet: snippet}
    end

    def logged_in_storytime_user?
      user_signed_in? && current_user.respond_to?(:storytime_user?) && current_user.storytime_user?(current_storytime_site)
    end
  end
end
