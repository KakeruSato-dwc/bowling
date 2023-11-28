class Admin::ReservationsController < ApplicationController
  def index
    @reservations = Reservation.page(params[:page]).where("start_date < ?", Date.current)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])
    if @reservation.update(reservation_params)
      redirect_to admin_reservation_path(@reservation.id)
    else
      render :edit
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:group_name, :num_children, :num_students, :num_adults, :num_games, :num_lanes, :start_date, :start_time, :note, :games_fee, :is_active)
  end
end
