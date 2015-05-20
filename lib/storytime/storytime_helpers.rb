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
  end
end
