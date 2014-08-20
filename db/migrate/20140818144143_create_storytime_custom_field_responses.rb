class CreateStorytimeCustomFieldResponses < ActiveRecord::Migration
  def change
    create_table :storytime_custom_field_responses do |t|
      t.belongs_to :post, index: true
      t.belongs_to :custom_field, index: true
      t.string :value

      t.timestamps
    end

    add_index :storytime_custom_field_responses, [:post_id, :custom_field_id, :value], name: "index_st_cust_field_resp_on_post_field_and_value"
  end
end