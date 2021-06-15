# app/models/invoice_items

class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :discounted_items
  enum status: [:pending, :packaged, :shipped]

  def self.total_revenue
    sum("invoice_items.unit_price * invoice_items.quantity")
  end

  # Needs testing
  def full_priced?
    self.discounted_items.empty?
  end

  # Needs testing
  def discount
    self.discounted_items.joins(:bulk_discount).select("bulk_discounts.*").first
  end
end
