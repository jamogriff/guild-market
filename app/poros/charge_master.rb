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
      binding.pry
      items.each do |item|
        DiscountedItem.create!(invoice_item: item, bulk_discount: set.first, 
                               percentage_discount: set.first.percentage_discount,
                               quantity: item.quantity)
      end
    end
    binding.pry
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
