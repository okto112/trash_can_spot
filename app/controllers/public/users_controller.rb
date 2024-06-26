class Public::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :current_user_find
  before_action :check_active_user
  before_action :edit_guest_user, only: [:edit]
  before_action :withdrawal_guest_user, only: [:unsubscribe, :withdraw]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to public_users_my_page_path
      flash[:notice] = "ユーザー情報を編集しました!"
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
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

  def current_user_find
    @user = User.find(current_user.id)
  end

  def edit_guest_user
    if @user.guest_user?
      redirect_to public_users_my_page_path , alert: "ゲストユーザーはユーザー情報を編集できません。"
    end
  end

  def withdrawal_guest_user
    if @user.guest_user?
      redirect_to public_users_my_page_path , alert: "ゲストユーザーは退会できません。"
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
