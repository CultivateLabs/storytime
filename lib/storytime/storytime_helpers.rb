module Storytime
  module StorytimeHelpers
    def storytime_snippet(name)
      snippet = Storytime::Snippet.find_by(name: name)
      if snippet.nil?
        ""
      else
        render snippet
      end
    end
  end
end