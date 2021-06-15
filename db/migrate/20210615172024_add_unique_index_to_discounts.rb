class AddUniqueIndexToDiscounts < ActiveRecord::Migration[5.2]
  def change
    remove_index :discounted_items, column: :invoice_item_id
    #add_column :discounted_items, :invoice_item_id, foreign_key: true, unique: true
    add_index :discounted_items, :invoice_item_id, unique: true
  end
end
