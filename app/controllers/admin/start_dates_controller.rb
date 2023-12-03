class Admin::StartDatesController < ApplicationController
  def index
    @start_date = StartDate.new
  end

  def create
    @start_date = StartDate.new(start_date_params)
    @start_date.save
    redirect_to new_admin_start_date_start_time_path(@start_date.id)
  end

  def show
    @start_date = StartDate.find(params[:id])
  end

  def destroy
    start_date = StartDate.find(params[:id])
    start_date.destroy
    redirect_to admin_start_dates_path
  end

  private

  def start_date_params
    params.require(:start_date).permit(:start_date)
  end
end
