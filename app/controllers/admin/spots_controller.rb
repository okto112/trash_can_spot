class Admin::SpotsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :spot_find, except: [:index]
  before_action :acquisition_all_kind

  def index
    @title = "スポット"
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
      @title = User.find(params[:user_id]).name + "さんのスポット"
    else
      @spots = Spot.page(params[:page])
      @key_word = nil
    end
  end

  def show
  end

  def edit
  end

  def update
    spot_params[:introduction].gsub!(/\r\n+/, '')
    checked_kinds = params[:spot][:kind_ids]

    Spot.transaction do
      if @spot.update(spot_params)
        if checked_kinds.nil?
          @spot.errors.add(:kind_ids, "を1つ以上選択してください")
          render :edit and return
        end
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
          render :edit
        end

      else
        if checked_kinds.nil?
          @spot.errors.add(:kind_ids, "を1つ以上選択してください")
        end
        @spot.name = Spot.find(params[:id]).name
        @spot.introduction = Spot.find(params[:id]).introduction
        render :edit
      end
    end
  end

  def destroy
    @spot.destroy
    flash[:notice] = "「#{@spot.name}」を削除しました。"
    redirect_to admin_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :introduction, :latitude, :longitude,  kind_ids: [] )
  end

  def spot_find
    @spot = Spot.find(params[:id])
  end

  def acquisition_all_kind
    @kinds = Kind.all
  end
end
