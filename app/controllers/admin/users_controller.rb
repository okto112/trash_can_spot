class Admin::UsersController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    if params[:key_word] != nil
      @users = User.where("id LIKE ? OR name LIKE ? OR email LIKE ?", "%#{params[:key_word]}%", "%#{params[:key_word]}%", "%#{params[:key_word]}%").page(params[:page])
      if @users.empty?
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @key_word = params[:key_word]
    else
      @users = User.page(params[:page])
      @key_word = nil
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to admin_user_path(@user.id)
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_active )
  end
end
