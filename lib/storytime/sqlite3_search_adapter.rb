module Storytime
  class Sqlite3SearchAdapter
    def self.search(search_string, search_model=Storytime::Post)
      search_model.where("lower(content) LIKE ? OR lower(title) LIKE ?", "%#{search_string}%", "%#{search_string}%")
    end
  end
end