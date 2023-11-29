class Admin::ReservationsController < ApplicationController
  def index
    reservations = Reservation.page(params[:page]).where("start_date < ?", Date.current)
    @reservations = reservations.order(start_time: :asc).order(start_date: :asc)
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
      fixed_games_fee = @reservation.num_children * 400 + @reservation.num_students * 500 + @reservation.num_adults * 600
      @reservation.update(games_fee: fixed_games_fee)
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
