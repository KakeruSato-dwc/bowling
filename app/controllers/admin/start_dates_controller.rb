class Admin::StartDatesController < ApplicationController
  before_action :set_beginning_of_week

  def index
    @start_date = StartDate.new
    @start_times = 20.times{@start_date.start_times.build}
    @reservations = Reservation.all
  end

  def num_lanes
    @start_date = StartDate.new(start_date_params)
    @start_times = 20.times{@start_date.start_times.build}
    render :num_lanes
  end

  def create
    @start_date = StartDate.new(start_date_params)
    @start_date.save
    redirect_to "/admin/start_dates?start_date=#{@start_date.start_date}"
  end

  def show
    @start_date = StartDate.find(params[:id])
    start_times = @start_date.start_times.all
    @start_times_first = start_times.first(10)
    @start_times_second = start_times.last(10)
    @reservations = Reservation.where(start_date: @start_date.start_date, is_active: true)
  end

  def edit
    @start_date = StartDate.find(params[:id])
    @start_times = @start_date.start_times.all
  end

  def update
    @start_date = StartDate.find(params[:id])
    @start_date.update(start_date_params)
    redirect_to admin_start_date_path(@start_date.id)
  end

  def destroy
    start_date = StartDate.find(params[:id])
    start_date.destroy
    redirect_to admin_start_dates_path
  end

  private

  def set_beginning_of_week
    Date.beginning_of_week = :sunday
  end

  def start_date_params
    params.require(:start_date).permit(:start_date, :is_active,
      start_times_attributes: [:id, :start_time, :num_available_lanes]
    )
  end
end
