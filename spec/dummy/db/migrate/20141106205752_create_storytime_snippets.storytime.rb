# This migration comes from storytime (originally 20141021073356)
class CreateStorytimeSnippets < ActiveRecord::Migration
  def up
    create_table :storytime_snippets do |t|
      t.string :name, index: true
      t.text :content

      t.timestamps
    end

    Storytime::Role.seed
    Storytime::Action.seed

    manage_snippets = Storytime::Action.find_by(guid: "5qg25i")
    Storytime::Permission.find_or_create_by(role: Storytime::Role.find_by(name: "editor"), action: manage_snippets)
    Storytime::Permission.find_or_create_by(role: Storytime::Role.find_by(name: "admin"), action: manage_snippets)
  end

  def down
    drop_table :storytime_snippets
  end
end
