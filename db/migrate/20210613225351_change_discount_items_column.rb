class ChangeDiscountItemsColumn < ActiveRecord::Migration[5.2]
  def change
    change_column :discounted_items, :percentage_discount, :float
  end
end
