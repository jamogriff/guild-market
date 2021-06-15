# app/controllers/invoice_controller.rb

class Admin::InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])

    # This is really a has_one and not a has_many association,
    # but reconfiguring that broke a ton of dependencies
    @merchant = @invoice.merchants.first
    ChargeMaster.apply_discounts(@invoice.id, @merchant.bulk_discounts)
  end

  def update
    @invoice = Invoice.find(params[:id])
    @invoice.update(invoice_params)

    render 'show'
  end

  private

  def invoice_params
    params.require(:invoice).permit(:status,
                  :customer_id)
  end
end
