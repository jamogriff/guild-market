class Merchants::InvoicesController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @invoices = @merchant.invoices.uniq
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @bulk_discounts = @merchant.bulk_discounts
    @invoice = Invoice.find(params[:id])
    @invoice_items = @invoice.invoice_items
    
    # ChargeMaster applies correct disount to all of invoice's items
    # There's a unique constraint at database level that won't allow 
    # duplicate records in DiscountedItems
    @apply_discounts ||= ChargeMaster.apply_discounts(@invoice.id, @bulk_discounts)
  end

  def update
    merchant = Merchant.find(params[:merchant_id])
    invoice = Invoice.find(params[:id])
    invoice_item = InvoiceItem.find(params[:ii_id])
    invoice_item.update(:status => params[:status] )
    invoice_item.save
    
    redirect_to "/merchants/#{merchant.id}/invoices/#{invoice.id}"
    flash[:notice] = "Item status successfully updated!"
  end
end

# private

#   def invoice_item_params
#     params.require(:invoice_item).permit(:status)
#   end
