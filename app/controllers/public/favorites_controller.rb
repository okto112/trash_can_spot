class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @favorite = Favorite.new(user_id: current_user.id, spot_id: params[:spot_id])
    @favorite.save
  end

  def destroy
    @favorite = Favorite.find_by(user_id: current_user.id, spot_id: params[:spot_id])
    @favorite.destroy
  end
end
