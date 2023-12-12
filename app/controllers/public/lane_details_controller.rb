class Public::LaneDetailsController < ApplicationController
  def create
    @lane_detail = LaneDetail.new(lane_detail_params)
    @lane_detail.save
    redirect_to members_path(params[:lane_detail][:reservation_id])
  end

  def update
    @lane_detail = LaneDetail.find(params[:id])
    @lane_detail.update(lane_detail_params)
    redirect_to members_path(@lane_detail.reservation_id)
  end

  def destroy
    lane_detail = LaneDetail.find(params[:id])
    lane_detail.destroy
    redirect_to members_path(lane_detail.reservation_id)
  end

  private

  def lane_detail_params
    params.require(:lane_detail).permit(:reservation_id, :name_1, :name_2, :name_3, :name_4)
  end
end
