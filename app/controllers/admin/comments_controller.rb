class Admin::CommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @comments = Comment.page(params[:page])
  end

  def show
    @comment = Comment.find(params[:id])
    @spot = Spot.find(@comment.spot_id)
    @kinds = Kind.all
  end

  def edit
    @comment = Comment.find(params[:id])
    @spot = Spot.find(@comment.spot_id)
    @kinds = Kind.all
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to admin_comment_path(@comment.id)
      flash[:notice] = "コメントを編集しました!"
    else
      @spot = Spot.find(@comment.spot_id)
      @kinds = Kind.all
      render :edit
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      redirect_to admin_comments_path
      flash[:notice] = "コメントを削除しました。"
    else
      @comments = Comment.page(params[:page])
      render :index
      flash.now[:alert] = "コメントを削除できませんでした。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :spot_id, :comment)
  end
end
