class Admin::KindsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @kinds = Kind.all.page(params[:page])
  end

  def new
    @kind = Kind.new
  end

  def edit
    @kind = Kind.find(params[:id])
  end

  def create
    @kind = Kind.new(kind_params)
    if @kind.save
      redirect_to admin_kinds_path
      flash[:notice] = "「#{@kind.name}」を追加しました!"
    else
      render :new
    end
  end

  def update
    @kind = Kind.find(params[:id])
    if @kind.update(kind_params)
      redirect_to admin_kinds_path
      flash[:notice] = "「#{@kind.name}」を編集しました!"
    else
      @kind = Kind.find(@kind.id)
      render :edit
    end
  end

  def destroy
    kind = Kind.find(params[:id])
    kind.spot_kinds.each do |spot_kind|
      spot_kind.spot.destroy if spot_kind.spot.spot_kinds.count == 1
    end
    if kind.destroy
      redirect_to admin_kinds_path
      flash[:notice] = "「#{kind.name}」を削除しました。"
    else
     @kinds = Kind.all.page(params[:page])
      render :index
      flash.now[:alert] = "「#{kind.name}」を削除できませんでした。"
    end
  end

  private

  def kind_params
    params.require(:kind).permit(:name, :color )
  end
end
