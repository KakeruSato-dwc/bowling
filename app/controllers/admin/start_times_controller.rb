class Admin::StartTimesController < ApplicationController
  def new
    @start_date = StartDate.find(params[:start_date_id])
  end

  def create
  end

  def update
  end
end
