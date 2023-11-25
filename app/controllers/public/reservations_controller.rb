class Public::ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
  end

  def select_time
  end

  def confirm
  end

  def create
  end

  def complete
  end

  def index
  end

  def show
  end

  def confirm_cancel
  end

  def cancel
  end

  private

  def reservation_params
    params.require(:reservation).permit(:group_name, :num_children, :num_students, :num_adults, :num_games, :num_lanes, :start_date, :start_time, :note, :games_fee)
  end
end
