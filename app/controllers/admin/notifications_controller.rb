class Admin::NotificationsController < ApplicationController
  def index
    @notifications = Notification.order(created_at: :desc).page(params[:page]).per(10)
    @num_new_notifications = @notifications.where(checked: false).count
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
