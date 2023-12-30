class Public::ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_matching_login_user, only: [:show, :confirm_cancel]

  def new
    @reservation = Reservation.new
  end


  def select_time
    @reservation = Reservation.new(reservation_params)
    # 団体名がない場合は、次の画面に進めない
    unless params[:reservation][:group_name].presence
      flash.now[:caution] = "団体名を記入してください"
      render :new
      return
    end
    # 予約人数が0人の場合は、次の画面に進めない
    if "#{params[:reservation][:num_children]}" == "0" && "#{params[:reservation][:num_students]}" == "0" && "#{params[:reservation][:num_adults]}" == "0"
      flash.now[:danger] = "0人では予約できません"
      render :new
      return
    end
    # 日付が選択されていない場合は、次の画面に進めない
    unless params[:reservation][:group_name].presence
      flash.now[:alert] = "日付を入力してください"
      render :new
      return
    end
    startdate = StartDate.find_by(start_date: params[:reservation][:start_date])
    # 選択した日付の残レーン数がまだ管理者側で登録されていない場合、次の画面に進めない
    unless startdate
      flash.now[:alert] = "この日は予約不可能となっております"
      render :new
      return
    end
    # 選択した日付が予約不可の場合、次の画面に進めない
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
    # 「戻る」ボタンを押すと、前の画面に戻る
    if params[:back]
      render :new
      return
    end
    @start_date = StartDate.find_by(start_date: @reservation.start_date)
    @start_date.start_times.each do |start_time|
      time = start_time.start_time
      if time.strftime("%H:%M") == "#{params[:reservation]["start_time(4i)"]}:#{params[:reservation]["start_time(5i)"]}"
        # 予約で使われるレーン数が、予約のスタート日時における残レーン数を上回っている場合、次の画面に進めない
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
    # メンバー表を新しく入力するときは、使用レーン数の分だけのメン表を用意する
    unless @reservation.lane_details.presence
      @reservation.num_lanes.times{@reservation.lane_details.build}
    end
    # 「戻る」ボタンを押すと、前の画面に戻る
    if params[:back]
      render :select_time
      return
    end
    # 「メンバー表を入力」を押すと、メンバー表入力画面に移る
    if params[:member]
      render :create
      return
    end
    # 予約確定処理
    @start_date.start_times.each do |start_time|
      time = start_time.start_time
      # 残レーン数を、使用レーン数の分だけ引き算する
      if time.strftime("%H:%M") == @reservation.start_time.strftime("%H:%M")
        remaining_lanes = start_time.num_available_lanes - @reservation.num_lanes
        start_time.update(num_available_lanes: remaining_lanes)
      end
    end
    @reservation.save
    # 予約が行われた、という通知を作成する
    notification = Notification.new(
      action: "reserve",
      checked: false,
      reservation_id: @reservation.id
    )
    notification.save
    redirect_to complete_path
  end


  def members_table
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    # 「メンバー表の入力を取り止める」を押すとメンバー表が記入されていない状態で確認画面へ進む
    if params[:back]
      @reservation.lane_details.destroy_all
      render :confirm
      return
    end
    (1..@reservation.num_lanes).to_a.each do |i|
      # 第１投球者から第３投球者までの欄に名前がなければ、確認画面に進めない
      unless params[:reservation][:lane_details_attributes]["#{i-1}"][:name_1].presence && params[:reservation][:lane_details_attributes]["#{i-1}"][:name_2].presence && params[:reservation][:lane_details_attributes]["#{i-1}"][:name_3].presence
        render :create
        return
      end
    end
    render :confirm
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
      # キャンセルされた場合、予約されていた使用レーン数を、残レーン数に加える
      if time.strftime("%H:%M") == @reservation.start_time.strftime("%H:%M")
        fixed_lanes = start_time.num_available_lanes + @reservation.num_lanes
        start_time.update(num_available_lanes: fixed_lanes)
      end
    end
    # キャンセルされた、という通知を作成
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
