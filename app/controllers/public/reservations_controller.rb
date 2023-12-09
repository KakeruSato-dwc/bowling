class Public::ReservationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @reservation = Reservation.new
  end

  def select_time
    @reservation = Reservation.new(reservation_params)
    startdate = StartDate.find_by(start_date: params[:reservation][:start_date])
    unless startdate
      flash[:alert] = "この日は予約不可能となっております"
      render :new
      return
    end
    if startdate.is_active == false
      flash[:alert] = "この日は予約不可能となっております"
      render :new
      return
    end
    if "#{params[:reservation][:num_children]}" == "0" && "#{params[:reservation][:num_students]}" == "0" && "#{params[:reservation][:num_adults]}" == "0"
      flash[:danger] = "0人では予約できません"
      render :new
      return
    end
    @reservation.user_id = current_user.id
    @start_date = StartDate.find_by(start_date: params[:reservation][:start_date])
    render :select_time
  end

  def confirm
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    if params[:back]
      render :new
      return
    end
    @start_date = StartDate.find_by(start_date: @reservation.start_date)
    @start_date.start_times.each do |start_time|
      time = start_time.start_time
      if time.strftime("%H:%M") == "#{params[:reservation]["start_time(4i)"]}:#{params[:reservation]["start_time(5i)"]}"
        if @reservation.num_lanes > start_time.num_available_lanes
          render :select_time
          return
        end
      end
    end
    render :confirm
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    @start_date = StartDate.find_by(start_date: @reservation.start_date)
    if params[:back]
      render :select_time
      return
    end
    @start_date.start_times.each do |start_time|
      time = start_time.start_time
      if time.strftime("%H:%M") == @reservation.start_time.strftime("%H:%M")
        remaining_lanes = start_time.num_available_lanes - @reservation.num_lanes
        start_time.update(num_available_lanes: remaining_lanes)
      end
    end
    @reservation.save
    redirect_to complete_path
  end

  def complete
  end

  def index
    @reservations = current_user.reservations.order(created_at: :desc)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def confirm_cancel
    @reservation = Reservation.find(params[:id])
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    @reservation.update(is_active: false)
    redirect_to reservations_path
  end

  private

  def reservation_params
    params.require(:reservation).permit(:group_name, :num_children, :num_students, :num_adults, :num_games, :num_lanes, :start_date, :start_time, :note, :games_fee)
  end
end
