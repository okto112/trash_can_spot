class Public::HomesController < ApplicationController

  def top
  end

  def main
    if params[:key_word] != nil
      @spots = Spot.where("name LIKE ? OR introduction LIKE ?", "%#{params[:key_word]}%", "%#{params[:key_word]}%")
      @key_word = params[:key_word]
      @kinds = Kind.all
    elsif params[:kind_id] != nil
      @spotkinds = SpotKind.where(kind_id: params[:kind_id])
      @spots = Spot.where(id: @spotkinds.pluck(:spot_id))
      @kinds = Kind.all
    else
      @spots = Spot.all
      @kinds = Kind.all
    end
  end
end
