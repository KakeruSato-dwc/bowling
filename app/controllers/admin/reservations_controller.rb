class Admin::ReservationsController < ApplicationController
  def index
    reservations = Reservation.page(params[:page]).where("start_date < ?", Date.current)
    @reservations = reservations.order(start_date: :desc, start_time: :desc)
  end

  def show
    @reservation = Reservation.find(params[:id])
    @lane_details = @reservation.lane_details.all
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @lane_details = @reservation.lane_details.all
  end

  def update
    @reservation = Reservation.find(params[:id])
    status = @reservation.is_active
    @lane_details = @reservation.lane_details.all
    @start_date = StartDate.find_by(start_date: @reservation.start_date)
    if @reservation.update(reservation_params)
      fixed_games_fee = (@reservation.num_children * 400 + @reservation.num_students * 500 + @reservation.num_adults * 600) * @reservation.num_games
      @reservation.update(games_fee: fixed_games_fee)
      @start_date.start_times.each do |start_time|
        time = start_time.start_time
        if time.strftime("%H:%M") == @reservation.start_time.strftime("%H:%M")
          # 「有効」から「キャンセル」に編集したとき
          if status == true && @reservation.is_active == false
            fixed_lanes = start_time.num_available_lanes + @reservation.num_lanes
            start_time.update(num_available_lanes: fixed_lanes)
          # 「キャンセル」から「有効」に編集したとき
          elsif status == false && @reservation.is_active == true
            fixed_lanes = start_time.num_available_lanes - @reservation.num_lanes
            start_time.update(num_available_lanes: fixed_lanes)
          end
        end
      end
      redirect_to admin_reservation_path(@reservation.id)
    else
      render :edit
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:group_name, :num_children, :num_students, :num_adults, :num_games, :num_lanes, :start_date, :start_time, :note, :games_fee, :is_active,
      lane_details_attributes: [:id, :name_1, :name_2, :name_3, :name_4]
    )
  end
end
