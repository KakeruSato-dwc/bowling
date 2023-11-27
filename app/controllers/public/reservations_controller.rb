class Public::ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
  end

  def select_time
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    render :select_time
  end

  def confirm
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    if params[:back]
      render :new
      return
    end
    render :confirm
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    if params[:back]
      render :select_time
      return
    end
    @reservation.save
    redirect_to complete_path
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
