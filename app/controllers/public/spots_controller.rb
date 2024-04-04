class Public::SpotsController < ApplicationController
  before_action :authenticate_user!
  def index
    @spots = Spot.where(user_id: current_user.id).page(params[:page])
  end

  def show
    @spot = Spot.find(params[:id])
  end

  def new
    @spot = Spot.new
  end

  def create
    @spot = Spot.new(spot_params)
    # @spot.kind = spot_params[:kind].map(&:to_sym) if spot_params[:kind].present?
    if @spot.save
      flash[:notice] = "スポットを登録しました！"
      redirect_to spots_path
    else
      @spots = Spot.where(user_id: current_user.id).page(params[:page])
      render :index
    end
  end
  
  def destroy
    spot = Spot.find(params[:id])
    spot.destroy
    redirect_to public_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :introduction, kind:[])
  end
end
