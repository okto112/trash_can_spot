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
    checked_kinds = params[:spot][:kind_ids]

    Spot.transaction do
      if @spot.save
        checked_kinds.each do |kind_id|
          if SpotKind.find_by(spot_id: @spot.id, kind_id: kind_id)
            break
          end

          spot_kind = SpotKind.create(spot_id: @spot.id, kind_id: kind_id)
          unless spot_kind.valid?
            @spot.errors.add(:kinds, spot_kind.errors[:kind_id])
          end
        end

        if @spot.errors.empty?
          flash[:notice] = "スポットを登録しました！"
          redirect_to public_spots_path
        else
          @kinds = Kind.all
          render :new
        end
      else
        @kinds = Kind.all
        render :new
      end
    end
  end

  def edit
    @spot = Spot.find(params[:id])
    @kinds = Kind.all
  end

  def update
    @spot = Spot.find(params[:id])
    checked_kinds = params[:spot][:kind_ids]

    if checked_kinds.nil?
      @spot.errors.add(:kind_ids, "を1つ以上選択してください")
      @kinds = Kind.all
      render :edit and return
    end

    Spot.transaction do
      if @spot.update(spot_params)
        checked_kinds.each do |kind_id|
          if SpotKind.find_by(spot_id: @spot.id, kind_id: kind_id)
            break
          end

          spot_kind = SpotKind.create(spot_id: @spot.id, kind_id: kind_id)
          unless spot_kind.valid?
            @spot.errors.add(:kinds, spot_kind.errors[:kind_id])
          end
        end

        if @spot.errors.empty?
          flash[:notice] = "スポットを編集しました！"
          redirect_to public_spot_path(@spot.id)
        else
          @kinds = Kind.all
          render :edit
        end
      else
        @kinds = Kind.all
        render :edit
      end
    end
  end

  def destroy
    spot = Spot.find(params[:id])
    spot.destroy
    flash[:notice] = "スポットを削除しました。"
    redirect_to public_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :introduction, :latitude, :longitude,  kind_ids: [] )
  end
end
