class Admin::HomesController < ApplicationController
  def top
    reservations = Reservation.page(params[:page]).where("start_date >= ?", Date.current)
    @reservations = reservations.order(start_time: :asc).order(start_date: :asc)
  end

  def about
    @reservation_today = Reservation.where("created_at > ?", Date.yesterday).where("created_at <= ?", Date.tomorrow).order(start_time: :asc).order(start_date: :asc)
    @reservation_yesterday = Reservation.where("created_at > ?", Date.current.ago(2.days)).where("created_at < ?", Date.today).order(start_time: :asc).order(start_date: :asc)
  end
end
