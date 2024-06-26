class Admin::CommentsController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!
  before_action :data_acquisition, except: [:index, :new, :create]

  def index
    @title = "コメント"
    if params[:key_word] != nil
      @comments = Comment.where("comment LIKE ?", "%#{params[:key_word]}%").page(params[:page])
      @users = User.where("name LIKE ?", "%#{params[:key_word]}%")
      @spots = Spot.where("name LIKE ?", "%#{params[:key_word]}%")
      if @comments.any? && @users.any? && @spots.any? || @comments.any? && @users.any? || @comments.any? && @spots.any?
        comment_ids = @comments.pluck(:id)
        user_ids = @users.pluck(:id)
        spot_ids = @spots.pluck(:id)
        @comments = Comment.where(id: comment_ids).page(params[:page])
        @comments = @comments.or( Comment.where(user_id: user_ids).page(params[:page]))
        @comments = @comments.or(Comment.where(spot_id: spot_ids).page(params[:page]))
      elsif @comments.empty? && @users.any? && @spots.any?
        user_ids = @users.pluck(:id)
        spot_ids = @spots.pluck(:id)
        @comments = Comment.where(user_id: user_ids).page(params[:page])
        @comments = @comments.or(Comment.where(spot_id: spot_ids).page(params[:page]))
      elsif @comments.empty? && @users.any? && @spots.empty?
        user_ids = @users.pluck(:id)
        @comments = Comment.where(user_id: user_ids).page(params[:page])
      elsif @comments.empty? && @users.empty? && @spots.any?
        spot_ids = @spots.pluck(:id)
        @comments = Comment.where(spot_id: spot_ids).page(params[:page])
      elsif @comments.empty? && @users.empty? && @spots.empty?
        flash.now[:alert] = "該当するスポットは見つかりませんでした。"
      end
      @key_word = params[:key_word]
    elsif params[:user_id] != nil
      @comments = Comment.where(user_id: params[:user_id]).page(params[:page])
      @key_word = nil
      @title = User.find(params[:user_id]).name + "さんのコメント"
    else
      @comments = Comment.page(params[:page])
      @key_word = nil
    end
  end

  def show
  end

  def edit
  end

  def update
    comment_params[:comment].gsub!(/\r\n+/, '')
    @comment = Comment.find(params[:id])
    if @comment.update(comment_params)
      redirect_to admin_comment_path(@comment.id)
      flash[:notice] = "コメント内容を編集しました!"
    else
      @spot = Spot.find(@comment.spot_id)
      @kinds = Kind.all
      render :edit
    end
  end

  def destroy
    if @comment.destroy
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

  def data_acquisition
    @comment = Comment.find(params[:id])
    @spot = Spot.find(@comment.spot_id)
    @kinds = Kind.all
  end
end
