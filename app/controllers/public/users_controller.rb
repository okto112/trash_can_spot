class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :edit_guest_user, only: [:edit]
  before_action :unsubscribe_guest_user, only: [:unsubscribe, :withdraw]

  def show
    @user = User.find(current_user.id)
  end

  def edit
    @user = User.find(current_user.id)
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to public_users_my_page_path
      flash[:notice] = "ユーザー情報を編集しました!"
    else
      render :edit
    end
  end

  def unsubscribe
    @user = User.find(current_user.id)
  end

  def withdraw
    @user = User.find(current_user.id)
    if @user.update(user_params)
      sign_out(current_user)
      redirect_to root_path
      flash[:notice] = "ゴミ箱スポットから退会しました。"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_active )
  end

  def edit_guest_user
    @user = User.find(current_user.id)
    if @user.guest_user?
      redirect_to public_users_my_page_path , alert: "ゲストユーザーはユーザー情報を編集できません。"
    end
  end

  def withdrawal_guest_user
    @user = User.find(current_user.id)
    if @user.guest_user?
      redirect_to public_users_my_page_path , alert: "ゲストユーザーは退会できません。"
    end
  end
end
