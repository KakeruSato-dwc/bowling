class Admin::NotificationsController < ApplicationController
  def index
    @notifications = Notification.all.order(created_at: :desc)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
