class AddStorytimeNameToUsers < ActiveRecord::Migration
  def change
    add_column Storytime.user_class.table_name.to_sym, :storytime_name, :string
  end
end
