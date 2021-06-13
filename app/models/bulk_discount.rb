class BulkDiscount < ApplicationRecord 
  belongs_to :merchant
  has_many :discounted_items
  has_many :invoice_items, through: :discounted_items
  validates_presence_of :percentage_discount
  validates_presence_of :quantity_threshold
  validates_numericality_of :percentage_discount, greater_than_or_equal_to: 0.01, less_than_or_equal_to: 1
  validates_numericality_of :quantity_threshold, only_integer: true, greater_than_or_equal_to: 5, less_than_or_equal_to: 1000
end

