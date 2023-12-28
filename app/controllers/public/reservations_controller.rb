class Public::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:show, :confirm_cancel]

  def new
    @reservation = Reservation.new
  end

  def select_time
    @reservation = Reservation.new(reservation_params)
    unless params[:reservation][:group_name].presence
      flash.now[:caution] = "団体名を記入してください"
      render :new
      return
    end
    if "#{params[:reservation][:num_children]}" == "0" && "#{params[:reservation][:num_students]}" == "0" && "#{params[:reservation][:num_adults]}" == "0"
      flash.now[:danger] = "0人では予約できません"
      render :new
      return
    end
    startdate = StartDate.find_by(start_date: params[:reservation][:start_date])
    unless startdate
      flash.now[:alert] = "この日は予約不可能となっております"
      render :new
      return
    end
    if startdate.is_active == false
      flash.now[:alert] = "この日は予約不可能となっております"
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
        if params[:reservation][:num_lanes].to_i > start_time.num_available_lanes
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
    unless @reservation.lane_details.presence
      @reservation.num_lanes.times{@reservation.lane_details.build}
    end
    if params[:back]
      render :select_time
      return
    end
    if params[:member]
      render :create
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
    notification = Notification.new(
      action: "reserve",
      checked: false,
      reservation_id: @reservation.id
    )
    notification.save
    redirect_to complete_path
  end

  def complete
  end

  def index
    @reservations = current_user.reservations.order(created_at: :desc)
  end

  def show
    @reservation = Reservation.find(params[:id])
    @lane_details = @reservation.lane_details
  end

  def confirm_cancel
    @reservation = Reservation.find(params[:id])
  end

  def cancel
    @reservation = Reservation.find(params[:id])
    @reservation.update(is_active: false)
    @start_date = StartDate.find_by(start_date: @reservation.start_date)
    @start_date.start_times.each do |start_time|
      time = start_time.start_time
      if time.strftime("%H:%M") == @reservation.start_time.strftime("%H:%M")
        fixed_lanes = start_time.num_available_lanes + @reservation.num_lanes
        start_time.update(num_available_lanes: fixed_lanes)
      end
    end
    notification = Notification.new(
      action: "cancel",
      checked: false,
      reservation_id: @reservation.id
    )
    notification.save
    redirect_to reservations_path
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update(reservation_params)
    redirect_to reservation_path(@reservation.id)
  end

  def destroy
    reservation = Reservation.find(params[:id])
    lane_details = reservation.lane_details.all
    lane_details.destroy_all
    redirect_to members_path(reservation.id)
  end

  def members
    @reservation = Reservation.find(params[:id])
    @lane_detail = LaneDetail.new
    @lane_details = @reservation.lane_details.all
  end

  private

  def reservation_params
    params.require(:reservation).permit(:group_name, :num_children, :num_students, :num_adults, :num_games, :num_lanes, :start_date, :start_time, :note, :games_fee,
      lane_details_attributes: [:id, :name_1, :name_2, :name_3, :name_4]
    )
  end

  def contification_params
    params.require(:notification).permit(:action, :checked, :reservation_id)
  end

  def is_matching_login_user
    reservation = Reservation.find(params[:id])
    unless reservation.user_id == current_user.id
      redirect_to "/reservations"
    end
  end
end
