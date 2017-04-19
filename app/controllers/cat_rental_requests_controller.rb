class CatRentalRequestsController < ApplicationController

  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(request_params)

    if @cat_rental_request.save
      @cat = Cat.find_by(id: request_params[:cat_id])
      redirect_to cat_url(@cat)
    else
      render :new
    end
  end

  private

  def request_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end
end
