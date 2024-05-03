class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_user, only: [:show, :edit]

  def index
    @comments = Comment.where(user_id: current_user.id).page(params[:page])
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

  def new
    @comment = Comment.new
    @spot = Spot.find(params[:spot_id])
    @kinds = Kind.all
  end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to public_comments_path
      flash[:notice] = "「#{@comment.comment}」を投稿しました!"
    else
      @spot = Spot.find(comment_params[:spot_id])
      @kinds = Kind.all
      render :new
    end
  end

  def update
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to public_comment_path(@comment.id)
      flash[:notice] = "「#{@comment.comment}」を編集しました!"
    else
      @spot = Spot.find(@comment.spot_id)
      @kinds = Kind.all
      render :edit
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.destroy
      redirect_to public_comments_path
      flash[:notice] = "「#{comment.comment}」を削除しました。"
    else
      @comments = Comment.where(user_id: current_user.id).page(params[:page])
      render :index
      flash.now[:alert] = "「#{comment.comment}」を削除できませんでした。"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :spot_id, :comment)
  end

  def check_user
    unless Comment.find(params[:id]).user_id == current_user.id
      flash[:alert] = "他のユーザーが投稿したコメントの詳細閲覧・編集はできません。"
      redirect_to public_comments_path
    end
  end
end
