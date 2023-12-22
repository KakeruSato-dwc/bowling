class Public::ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def index
    @reviews = Review.page(params[:page]).per(10)
    @review = Review.new
  end

  def create
    @reviews = Review.page(params[:page]).per(10)
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    unless params[:review][:valuation].presence
      render :index
      return
    end
    @review.save
    redirect_to reviews_path
  end

  def edit
    @review = Review.find(params[:id])
  end

  def update
    review = Review.find(params[:id])
    review.update(review_params)
    redirect_to reviews_path
  end

  def destroy
    @reviews = Review.page(params[:page]).per(10)
    @review = Review.new
    review = Review.find(params[:id])
    review.destroy
    redirect_to reviews_path
  end

  private

  def review_params
    params.require(:review).permit(:valuation, :body, :user_id)
  end
end
