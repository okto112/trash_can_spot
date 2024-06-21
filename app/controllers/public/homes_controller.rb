class Public::HomesController < ApplicationController
  before_action :authenticate_user!, except: [:top]
  before_action :check_active_user, except: [:top]
  before_action :all_data_acquisition

  def top
  end

  def main
    @screen_width = request.env["HTTP_USER_AGENT"].scan(/[\d]+/).first.to_i
    if params[:key_word] != nil
      @spots = Spot.where("name LIKE ? OR introduction LIKE ?", "%#{params[:key_word]}%", "%#{params[:key_word]}%")
      if @spots.empty?
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @key_word = params[:key_word]
      @kind_id = 0
    elsif params[:kind_id] != nil && params[:kind_id] != "0"
      @spotkinds = SpotKind.where(kind_id: params[:kind_id])
      @spots = Spot.where(id: @spotkinds.pluck(:spot_id))
      if @spots.empty?
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @kind_id = params[:kind_id]
    else
      @kind_id = 0
    end
  end

  private

  def check_active_user
    unless current_user&.is_active
      sign_out(current_user)
      flash[:alert] = "先程のアカウントは管理者より使用できなくなりました。"
      redirect_to root_path
    end
  end

  def all_data_acquisition
    @spots = Spot.all
    @comments = Comment.all
    @kinds = Kind.all
  end
end
