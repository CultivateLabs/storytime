module Storytime
  class MysqlFulltextSearchAdapter
    def self.search(search_string, search_model=Storytime::Post)
      search_model.where("MATCH(content, title) AGAINST (? IN NATURAL LANGUAGE MODE)", search_string)
    end
  end
end