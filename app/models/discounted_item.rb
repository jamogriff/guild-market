class DiscountedItem < ApplicationRecord
  belongs_to :invoice_item
  belongs_to :bulk_discount
  validates :invoice_item_id, uniqueness: true
end
