class Merchants::BulkDiscountsController < ApplicationController
  rescue_from ApiConnectionError, with: :connection_error

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @calendar = CalendarService.next_three_holidays
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private

  # This will have to be explored at a later time,
  # Utilizing a serializer will allow to render out the error
  # and bypass making another API connection that will fail
  def connection_error(exception)
    flash[:raise] = "Error: #{exception.message}"
  end
end
