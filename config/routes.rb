Rails.application.routes.draw do
  namespace :admin do
    root to: "homes#top"
  end

  root to: "public/homes#top"
  get "/fee" => "public/homes#about", as: "fee"

  devise_for :users, skip: [:password], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  namespace :admin do
    resources :start_times, only: [:new, :create, :update]
  end

  namespace :admin do
    resources :start_dates, only: [:new, :create, :index, :show]
  end

  namespace :admin do
    resources :reservations, only: [:index, :show, :edit, :update]
  end

  namespace :admin do
    resources :users, only: [:index, :show, :edit, :update]
  end

  get "/users/my_page" => "public/users#show", as: "my_page"
  get "/users/information/edit" => "public/users#edit", as: "edit_user_information"
  patch "/users/information" => "public/users#update", as: "update_user_information"

  scope module: "public" do
    resources :reservations, only: [:new, :create, :index, :show]
  end
  post "/reservations/select_time" => "public/reservations#select_time", as: "select_time"
  post "/reservations/confirm" => "public/reservations#confirm", as: "confirm"
  get "/complete" => "public/reservations#complete", as: "complete"
  get "/reservations/:id/confirm_cancel" => "public/reservations#confirm_cancel", as: "confirm_cancel"
  patch "/reservations/:id/cancel" => "public/reservations#cancel", as: "cancel"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
