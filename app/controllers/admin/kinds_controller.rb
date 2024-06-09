class Admin::KindsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :kind_find, except: [:index, :new, :create]

  def index
    @kinds = Kind.all.page(params[:page])
  end

  def new
    @kind = Kind.new
  end

  def edit
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
    if @kind.update(kind_params)
      redirect_to admin_kinds_path
      flash[:notice] = "「#{@kind.name}」を編集しました!"
    else
      @kind.name = Kind.find(@kind.id).name
      render :edit
    end
  end

  def destroy
    delete_flag = true
    @kind.spot_kinds.each do |spot_kind|
      if spot_kind.spot.spot_kinds.count > 0
        delete_flag = false
        break
      end
    end
    if delete_flag
      if @kind.destroy
        redirect_to admin_kinds_path
        flash[:notice] = "「#{@kind.name}」を削除しました。"
      else
        @kinds = Kind.all.page(params[:page])
        render :index
        flash.now[:alert] = "「#{@kind.name}」を削除できませんでした。"
      end
    else
      redirect_to admin_kinds_path
      flash[:alert] = "「#{@kind.name}」はスポットで使用されている為、削除できませんでした。"
    end
  end

  private

  def kind_params
    params.require(:kind).permit(:name, :color )
  end

  def kind_find
    @kind = Kind.find(params[:id])
  end
end
