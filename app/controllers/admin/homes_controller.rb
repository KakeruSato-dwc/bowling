class Admin::HomesController < ApplicationController
  def top
    @reservations = Reservation.page(params[:page]).where("start_date >= ?", Date.current)
  end
end
