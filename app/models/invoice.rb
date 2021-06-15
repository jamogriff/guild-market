# app/models/invoice

class Invoice < ApplicationRecord
  enum status: [ 'in progress', :completed, :cancelled ] # 0 => in progress, 1 => completed, etc 
  belongs_to :customer
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :transactions, dependent: :destroy
  has_many :merchants, through: :items

  def self.filter_by_unshipped_order_by_age
    joins(:invoice_items)
    .distinct.select("invoices.id, invoices.created_at")
    .where.not(invoice_items: {status: 'shipped'})
    .order(:created_at)
  end

  # Parameter doesn't need to be an array
  def quantities_between(array)
    invoice_items.where("invoice_items.quantity >= #{array[0]}").where("invoice_items.quantity < #{array[1]}")
  end

  def quantities_more_than(num)
    invoice_items.where("invoice_items.quantity >= #{num}")
  end

  def statuses
    ['in progress', 'completed', 'cancelled']
  end

  # Utilizes class method from InvoiceItems
  def revenue
    invoice_items.total_revenue
  end

  # Flex that left outer join
  def full_price_items
    invoice_items.left_outer_joins(:discounted_items).where("discounted_items.id IS null")
  end

  def discounted_items
    invoice_items.joins(:discounted_items)
  end

  # Result is a float
  def discounted_revenue
    discounted_items.sum("invoice_items.unit_price * invoice_items.quantity * discounted_items.percentage_discount")
  end

  # Uses left outer join to calculate revenue of invoice items that don't have an associated discount
  def remaining_revenue
    full_price_items.where("discounted_items.id IS null").sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def revenue_with_discounts
    discounted_revenue + remaining_revenue
  end
end
