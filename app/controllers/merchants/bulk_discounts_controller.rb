class Merchants::BulkDiscountsController < ApplicationController
  rescue_from ApiConnectionError, with: :connection_error

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @calendar = CalendarService.next_three_holidays
  end

  def show
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    discount = @merchant.bulk_discounts.new(discount_params)
    if discount.save
      redirect_to merchant_bulk_discounts_path(id: params[:merchant_id]) 
    else
      flash.now[:warning] = "Whoops! #{error_message(discount.errors)}"
      render :new
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private

  def discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end

  # This will have to be explored at a later time,
  # Utilizing a serializer will allow to render out the error
  # and bypass making another API connection that will fail
  def connection_error(exception)
    flash[:raise] = "Error: #{exception.message}"
  end
end
