class Admin::ReservationsController < ApplicationController
  def index
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
  end

  def update
  end
end
