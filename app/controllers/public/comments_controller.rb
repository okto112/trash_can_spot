class Public::CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :data_acquisition, except: [:index, :new, :create]
  before_action :check_user, only: [:show, :edit]
  before_action :check_destroy_comment, only: [:destroy]

  def index
    @comments = Comment.where(user_id: current_user.id).page(params[:page])
  end

  def show
  end

  def edit
  end

  def new
    @comment = Comment.new
    @spot = Spot.find(params[:spot_id])
  end

  def create
    comment_params[:comment].gsub!(/\r\n+/, '')
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to public_comments_path
      flash[:notice] = "コメント内容を投稿しました!"
    else
      @spot = Spot.find(comment_params[:spot_id])
      @kinds = Kind.all
      render :new
    end
  end

  def update
    comment_params[:comment].gsub!(/\r\n+/, '')
    if @comment.update(comment_params)
      redirect_to public_comment_path(@comment.id)
      flash[:notice] = "コメント内容を編集しました!"
    else
      render :edit
    end
  end

  def destroy
    if @comment.destroy
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

  def data_acquisition
    @comment = Comment.find(params[:id])
    @spot = Spot.find(@comment.spot_id)
    @kinds = Kind.all
  end

  def check_user
    unless Comment.find(params[:id]).user_id == current_user.id
      flash[:alert] = "他のユーザーが投稿したコメントの詳細閲覧・編集はできません。"
      redirect_to public_comments_path
    end
  end

  def check_destroy_comment
    unless Comment.find(params[:id]).user_id == current_user.id
      flash[:alert] = "他のユーザーが投稿したコメントは削除できません。"
      redirect_to public_comments_path
    end
  end
end
