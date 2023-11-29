class Admin::HomesController < ApplicationController
  def top
    reservations = Reservation.page(params[:page]).where("start_date >= ?", Date.current)
    @reservations = reservations.order(start_time: :asc).order(start_date: :asc)
  end
end
