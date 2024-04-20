class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @spot = Spot.find(params[:spot_id])
    @favorite = Favorite.new(user_id: current_user.id, spot_id: @spot.id)
    @favorite.save
  end

  def destroy
    @spot = Spot.find(params[:id])
    @favorite = Favorite.find_by(user_id: current_user.id, spot_id: @spot.id)
    @favorite.destroy
  end
end