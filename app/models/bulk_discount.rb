class BulkDiscount < ApplicationRecord 
  belongs_to :merchant
  has_many :discounted_items
  has_many :invoice_items, through: :discounted_items
end

