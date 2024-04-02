class Public::UsersController < ApplicationController
  before_action :authenticate_user!

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
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_active )
  end
end
