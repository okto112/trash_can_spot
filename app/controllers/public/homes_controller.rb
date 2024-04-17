class Public::HomesController < ApplicationController

  def top
  end

  def main
    if params[:key_word] != nil
      @spots = Spot.where("name LIKE ? OR introduction LIKE ?", "%#{params[:key_word]}%", "%#{params[:key_word]}%")
      if @spots == []
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @key_word = params[:key_word]
      @kinds = Kind.all
      @kind_id = 0
    elsif params[:kind_id] != nil && params[:kind_id] != "0"
      @spotkinds = SpotKind.where(kind_id: params[:kind_id])
      @spots = Spot.where(id: @spotkinds.pluck(:spot_id))
      if @spots == []
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @kinds = Kind.all
      @kind_id = params[:kind_id]
    else
      @spots = Spot.all
      @kinds = Kind.all
      @kind_id = 0
    end
  end
end
