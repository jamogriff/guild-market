class AddPriceColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :discounted_items, :unit_price, :integer
  end
end
