class Public::HomesController < ApplicationController
  def top
  end

  def about
  end

  def lane_status
    @start_dates = StartDate.where("start_date > ?", Date.current).order(start_date: :asc).page(params[:page]).per(7)
  end

  def map
  end
end
