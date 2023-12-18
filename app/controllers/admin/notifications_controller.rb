class Admin::NotificationsController < ApplicationController
  def index
    @notifications = Notification.order(created_at: :desc).page(params[:page]).per(10)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
