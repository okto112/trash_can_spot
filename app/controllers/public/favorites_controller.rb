class Public::FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_active_user
  before_action :check_user, only: [:show]
  before_action :check_favorite_create, only: [:create]

  def index
    @favorites = Favorite.where(user_id: current_user.id)
    @spots = Spot.where(id: @favorites.pluck(:spot_id)).page(params[:page])
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def create
    @spot = Spot.find(params[:spot_id])
    @favorite = Favorite.new(user_id: current_user.id, spot_id: @spot.id)
    @favorite.save
    flash.now[:notice] = "「#{@spot.name}」をお気に入りに追加しました。"
  end

  def destroy
    @spot = Spot.find(params[:id])
    @favorite = Favorite.find_by(user_id: current_user.id, spot_id: @spot.id)
    respond_to do |format|
      format.js {
        @favorite.destroy
        flash.now[:alert] = "「#{@spot.name}」をお気に入りから削除しました。"
      }
      format.html {
        @favorite.destroy
        redirect_to public_favorites_path, notice: "「#{@spot.name}」をお気に入り一覧から削除しました。"
      }
    end
  end

  private

  def check_user
    @favorites = Favorite.where(spot_id: params[:id])
    if @favorites.find_by(user_id: current_user.id).nil?
      flash[:alert] = "お気に入り登録していないスポットは閲覧できません。"
      redirect_to public_favorites_path
    end
  end

  def check_favorite_create
    @spot = Spot.find(params[:spot_id])
    @favorites = Favorite.where(spot_id: @spot.id)
    unless @favorites.find_by(user_id: current_user.id).nil?
      flash.now[:alert] = "既にお気に入り登録されています。"
      redirect_to public_favorites_path
    end
  end

  def check_active_user
    unless current_user&.is_active
      sign_out(current_user)
      flash[:alert] = "先程のアカウントは管理者より使用できなくなりました。"
      redirect_to root_path
    end
  end
end