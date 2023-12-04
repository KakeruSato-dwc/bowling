class Admin::StartDatesController < ApplicationController
  def index
    @start_date = StartDate.new
    @start_times = 21.times{@start_date.start_times.build}
  end

  def num_lanes
    @start_date = StartDate.new(start_date_params)
    @start_times = 21.times{@start_date.start_times.build}
    render :num_lanes
  end

  def create
    @start_date = StartDate.new(start_date_params)
    @start_date.save
    redirect_to admin_start_dates_path
  end

  def show
    @start_date = StartDate.find(params[:id])
    @start_times = @start_date.start_times.all
  end

  def destroy
    start_date = StartDate.find(params[:id])
    start_date.destroy
    redirect_to admin_start_dates_path
  end

  private

  def start_date_params
    params.require(:start_date).permit(:start_date,
      start_times_attributes: [:id, :start_time, :num_available_lanes]
    )
  end
end
