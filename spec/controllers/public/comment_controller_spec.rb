# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::CommentsController, type: :request do
  describe 'public/commens_controllerのテスト' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:test_user) { FactoryBot.create(:user) }
    let!(:kind) { FactoryBot.create(:kind) }
    let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }
    let!(:comment) { FactoryBot.create(:comment, user_id: user.id, spot_id: spot.id) }

    describe "before_actionのテスト" do
      context ':authenticate_user!のテスト' do
        it "未サインインの場合" do
          get public_users_my_page_path
          expect(response).to redirect_to(new_user_session_path)
        end

        it "サインインの場合" do
          sign_in user
          get public_users_my_page_path
          expect(response).to be_successful
        end
      end

      context ':data_acquisitionのテスト' do
        it "データを取得" do
          expect(Comment.exists?(comment.id)).to eq(true)
          expect(Spot.exists?(comment.spot_id)).to eq(true)
          expect(Kind.all.exists?).to eq(true)
        end
      end

      context ':check_userのテスト' do
        it "spotのデータを取得" do
          expect(Spot.all.exists?).to eq(true)
        end

        it "ログインユーザーが作成したスポットではない場合" do
          sign_in test_user
          get edit_public_spot_path(spot), params: { id: spot.id }
          expect(flash[:alert]).to eq('他のユーザーが登録したスポットの詳細閲覧・編集はできません。')
          expect(response).to redirect_to(public_spots_path)
        end
      end

      context ':check_destroy_commentのテスト' do
        it "ログインユーザーが作成したスポットではない場合" do
          sign_in test_user
          delete public_comment_path(comment), params: { id: comment.id }
          expect(flash[:alert]).to eq('他のユーザーが投稿したコメントは削除できません。')
          expect(response).to redirect_to(public_comments_path)
        end
      end
    end

    describe "各アクションのテスト" do
      before do
        sign_in user
      end

      context 'indexのテスト' do
        it 'ログインユーザーが作成したコメントのみを表示' do
          get public_comments_path, params: { comment: comment.attributes }
          expect(assigns(:comments)).to eq([comment])
        end
      end

      context 'newのテスト' do
        it 'スポット作成の確認' do
          get new_public_comment_path(spot_id: spot.id)
          expect(assigns(:comment)).to be_a_new(Comment)
        end
      end

      context 'createのテスト' do
        it 'コメント作成の確認' do
          post public_comments_path, params: { comment: { user_id: user.id, spot_id: spot.id, comment: comment.comment } }
          expect(flash[:notice]).to eq("コメント内容を投稿しました!")
          expect(response).to redirect_to(public_comments_path)
        end

        it "作成エラーの確認" do
          post public_comments_path, params: { comment: { comment: "", spot_id: spot.id} }
          expect(response).to render_template(:new)
        end
      end

      context 'updateのテスト' do
        it 'コメント情報の更新' do
          patch public_comment_path(comment), params: { comment: { id: comment.id, user_id: user.id, spot_id: spot.id, comment: "new_comment" } }
          expect(response).to redirect_to(public_comment_path(comment))
          expect(flash[:notice]).to eq("コメント内容を編集しました!")
        end

        it 'コメントト情報の更新に失敗した場合' do
          patch public_comment_path(comment), params: { comment: { comment: "" } }
          expect(response).to render_template(:edit)
        end
      end

      context 'destroyのテスト' do
        it 'コメントの削除ができた場合' do
          delete public_comment_path(comment)
          expect(response).to redirect_to(public_comments_path)
          expect(flash[:notice]).to eq("コメントを削除しました。")
        end

        it 'コメントの削除ができなかった場合' do
          allow_any_instance_of(Comment).to receive(:destroy).and_return(false)
          delete public_comment_path(comment)
          expect(response).to render_template(:index)
          expect(flash[:alert]).to eq("コメントを削除できませんでした。")
        end
      end
    end
  end
end