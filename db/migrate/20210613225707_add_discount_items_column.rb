class AddDiscountItemsColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :discounted_items, :quantity, :integer
  end
end
