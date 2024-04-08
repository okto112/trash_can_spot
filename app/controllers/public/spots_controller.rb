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
    @kinds = Kind.all
  end

  def create
    @spot = Spot.new(spot_params)
    checked_kinds = params[:kinds]

    Spot.transaction do
      if @spot.save
        checked_kinds.each do |kind_id|
          SpotKind.create(spot_id: @spot.id, kind_id: kind_id)
        end
        flash[:notice] = "スポットを登録しました！"
        redirect_to public_spots_path
      else
        @spots = Spot.where(user_id: current_user.id).page(params[:page])
        render :index
      end
    end
  end

  def destroy
    spot = Spot.find(params[:id])
    spot.destroy
    redirect_to public_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :introduction, :latitude, :longitude, kind:[])
  end
end
