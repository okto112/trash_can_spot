class Public::CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @comments = Comment.where(user_id: current_user.id).page(params[:page])
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new
    @comment = Comment.new
    @spot = Spot.find(params[:spot_id])
    @kinds = Kind.all
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to public_comments_path
      flash[:notice] = "コメントを投稿しました!"
    else
      @spot = Spot.find(comment_params[:spot_id])
      @kinds = Kind.all
      render :new
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      redirect_to public_comments_path
      flash[:notice] = "コメントを削除しました。"
    else
      @comments = Comment.where(user_id: current_user.id).page(params[:page])
      render :index
      flash.now[:alert] = "コメントを削除できませんでした。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :spot_id, :comment)
  end
end
