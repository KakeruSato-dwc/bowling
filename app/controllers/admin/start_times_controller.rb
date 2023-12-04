class Admin::StartTimesController < ApplicationController
  def new
    @start_date = StartDate.find(params[:start_date_id])
    @start_times = Form::StartTimeCollection.new
  end

  def create
    @start_date = StartDate.find(params[:start_date_id])
    @start_times = Form::StartTimeCollection.new(start_time_collection_params)
    if @start_times.save
      redirect_to admin_start_dates_path
    else
      render :new
    end
  end

  def update
  end

  private

  def start_time_collection_params
    params.require(:form_start_time_collection).permit(start_times_attributes: [:start_time, :num_available_lanes])
  end
end
