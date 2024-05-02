class Admin::SpotsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    if params[:key_word] != nil
      @spots = Spot.where("name LIKE ?", "%#{params[:key_word]}%").page(params[:page])
      @users = User.where("name LIKE ?", "%#{params[:key_word]}%")
      @kind = Kind.where(name: params[:key_word])
      if @spots.empty? && @users.any?
        user_ids = @users.pluck(:id)
        @spots = Spot.where(user_id: user_ids).page(params[:page])
      elsif @kind.any?
        kind_id = @kind.pluck(:id)
        @spot_kinds = SpotKind.where(kind_id: kind_id)
        spot_ids = @spot_kinds.pluck(:spot_id)
        @spots = Spot.where(id: spot_ids).page(params[:page])
      else
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @key_word = params[:key_word]
    elsif params[:user_id] != nil
      @spots = Spot.where(user_id: params[:user_id]).page(params[:page])
      @key_word = nil
    else
      @spots = Spot.page(params[:page])
      @key_word = nil
    end
  end

  def show
    @spot = Spot.find(params[:id])
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
          flash[:notice] = "「#{@spot.name}」を編集しました！"
          redirect_to admin_spot_path(@spot.id)
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
    flash[:notice] = "「#{spot.name}」を削除しました。"
    redirect_to admin_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :introduction, :latitude, :longitude,  kind_ids: [] )
  end
end
