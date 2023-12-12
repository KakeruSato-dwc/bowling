class Admin::HomesController < ApplicationController
  def top
    reservations = Reservation.page(params[:page]).where("start_date >= ?", Date.current)
    @reservations = reservations.order(start_date: :asc, start_time: :asc)
  end

  def about
    @reservation_today = Reservation.where(created_at: Time.zone.now.all_day).order(start_date: :asc, start_time: :asc)
    @reservation_yesterday = Reservation.where(created_at: 1.day.ago.all_day).order(start_date: :asc, start_time: :asc)
  end
end
