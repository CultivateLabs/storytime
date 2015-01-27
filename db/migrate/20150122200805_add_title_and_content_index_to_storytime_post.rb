class AddTitleAndContentIndexToStorytimePost < ActiveRecord::Migration
  def up
    if Storytime.search_adapter == Storytime::PostgresSearchAdapter
      execute "CREATE INDEX posts_title_contentx ON storytime_posts USING gin(to_tsvector('english', coalesce(title, '') || ' ' || coalesce(content, '')));"
    elsif Storytime.search_adapter == Storytime::MysqlSearchAdapter
      type = get_table_type
      version = get_mysql_version

      if (type == "MyISAM") || (type == "InnoDB" && Gem::Version.new(version) >= Gem::Version.new("5.6.4"))
        add_index :storytime_posts, [:title, :content], type: :fulltext, :length => 50
      elsif type == "InnoDB"
        add_index :storytime_posts, [:title, :content], :length => 50
      end
    elsif Storytime.search_adapter == Storytime::MysqlFulltextSearchAdapter
      add_index :storytime_posts, [:title, :content], type: :fulltext, :length => 50
    end
  end

  def down
    if Storytime.search_adapter == Storytime::PostgresSearchAdapter
      execute "REMOVE INDEX posts_title_contentx ON storytime_posts"
    elsif Storytime.search_adapter == Storytime::MysqlSearchAdapter
      type = get_table_type
      version = get_mysql_version

      if (type == "MyISAM") || (type == "InnoDB" && Gem::Version.new(version) >= Gem::Version.new("5.6.4"))
        remove_index :storytime_posts, [:title, :content], type: :fulltext
      elsif type == "InnoDB"
        remove_index :storytime_posts, [:title, :content]
      end
    elsif Storytime.search_adapter == Storytime::MysqlFulltextSearchAdapter
      remove_index :storytime_posts, [:title, :content], type: :fulltext
    end
  end

  def get_table_type
    config = Rails.configuration.database_configuration
    database_name = config[Rails.env]["database"]

    sql = "SELECT TABLE_NAME, ENGINE FROM information_schema.TABLES where TABLE_SCHEMA = '#{database_name}'"
    query = ActiveRecord::Base.connection.execute(sql)

    query.entries.each do |k,v|
      if k == "storytime_posts"
        return v
      end
    end
  end

  def get_mysql_version
    sql = "SELECT VERSION()"
    query = ActiveRecord::Base.connection.execute(sql)

    query.entries[0][0]
  end
end
