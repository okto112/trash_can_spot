class Public::SpotsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_active_user
  before_action :check_user, only: [:show, :edit]
  before_action :check_destroy_spot, only: [:destroy]

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

  def edit
    @spot = Spot.find(params[:id])
    @kinds = Kind.all
  end

  def create
    spot_params[:introduction].gsub!(/\r\n+/, '')
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
          flash[:notice] = "「#{@spot.name}」を登録しました！"
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

  def update
    spot_params[:introduction].gsub!(/\r\n+/, '')
    @spot = Spot.find(params[:id])
    checked_kinds = params[:spot][:kind_ids]

    Spot.transaction do
      if @spot.update(spot_params)
        if checked_kinds.nil?
          @spot.errors.add(:kind_ids, "を1つ以上選択してください")
          @kinds = Kind.all
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
          redirect_to public_spot_path(@spot.id)
        else
          @kinds = Kind.all
          render :edit
        end

      else
        if checked_kinds.nil?
          @spot.errors.add(:kind_ids, "を1つ以上選択してください")
        end
        @spot.name = Spot.find(params[:id]).name
        @spot.introduction = Spot.find(params[:id]).introduction
        @kinds = Kind.all
        render :edit
      end
    end
  end

  def destroy
    spot = Spot.find(params[:id])
    spot.destroy
    flash[:notice] = "「#{spot.name}」を削除しました。"
    redirect_to public_spots_path
  end

  private

  def spot_params
    params.require(:spot).permit(:user_id, :name, :introduction, :latitude, :longitude,  kind_ids: [] )
  end

  def check_user
    unless Spot.find(params[:id]).user_id == current_user.id
      flash[:alert] = "他のユーザーが登録したスポットの詳細閲覧・編集はできません。"
      redirect_to public_spots_path
    end
  end

  def check_destroy_spot
    unless Spot.find(params[:id]).user_id == current_user.id
      flash[:alert] = "他のユーザーが登録したスポットは削除できません。"
      redirect_to public_spots_path
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
