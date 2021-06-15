class ChargeMaster

  # There's a bug here that will leave out adding an invoice item if its quantity is equal to
  # the highest bulk discount threshold. This is due to how the quantities between method is written
  # TODO: Write a method that just selects invoice_items greater or equal to order_by_threshold.last
  def self.initialize_discounts(invoice_id, discounts)
    invoice = Invoice.find(invoice_id)
    ordered_discounts = discounts.order_by_threshold
    threshold_sets = ChargeMaster.create_subset(ordered_discounts)
    threshold_sets.each do |set|
      items = invoice.quantities_between([set.first.quantity_threshold, set.last.quantity_threshold])
      items.each do |item|
        DiscountedItem.create!(invoice_item: item, bulk_discount: set.first, 
                               percentage_discount: 1 - set.first.percentage_discount)
      end
    end
    # Ideally the below helper method could be refactored to oblivion
    ChargeMaster.initialize_largest_discount(invoice, ordered_discounts)
  end

  # Method intakes an invoice and assumes discount parameter is already ordered
  def self.initialize_largest_discount(invoice, discounts)
    largest_discount = discounts.last
    items = invoice.quantities_more_than(largest_discount.quantity_threshold)
    if !items.empty?
      items.each do |item|
        DiscountedItem.create!(invoice_item: item, bulk_discount: largest_discount, 
                               percentage_discount: 1 - largest_discount.percentage_discount)
      end
    end
  end

  # There's likely a built-in method that accomplishes this task,
  # but neither permutations or combinations captured it exactly
  def self.create_subset(array)
    return_array = []
    counter = 0
    while counter < (array.length - 1) do
      return_array << [array[counter], array[(counter + 1)]]
      counter += 1
    end
    return_array
  end

end
