module Storytime
  class PostgresSearchAdapter
    def self.search(search_string, search_model=Storytime::Post)
      search_terms = search_string.gsub(" ", " & ")

      search_model.where("to_tsvector(coalesce(title, '') || ' ' || coalesce(content, '')) @@ to_tsquery(?)", "#{search_terms}")
    end
  end
end