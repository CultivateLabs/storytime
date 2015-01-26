module Storytime
  class MysqlFulltextSearchAdapter
    def self.search(search_string, search_model=Storytime::Post)
      search_model.where("MATCH(content, title) AGAINST ('#{search_string}' IN NATURAL LANGUAGE MODE)")
    end
  end
end