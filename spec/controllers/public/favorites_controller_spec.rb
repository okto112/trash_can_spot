# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::FavoritesController, type: :request do
  describe 'public/favorites_controllerのテスト' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:test_user) { FactoryBot.create(:user) }
    let!(:kind) { FactoryBot.create(:kind) }
    let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }
    let!(:favorite) { Favorite.create(user_id: user.id, spot_id: spot.id) }

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

      context ':check_active_userのテスト' do
        it "ログイン中にis_activeがfalseになるとログアウトするかを確認" do
          sign_in user
          user.is_active = false
          get public_users_my_page_path
          sign_out user
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('先程のアカウントは管理者より使用できなくなりました。')
        end
      end

      context ':check_userのテスト' do
        it "favoriteのデータを取得" do
          expect(Favorite.exists?(spot_id: spot.id)).to eq(true)
        end

        it "ログインユーザーが登録したお気に入りではない場合" do
          sign_in test_user
          get public_favorite_path(favorite), params: { id: favorite.id }
          expect(flash[:alert]).to eq('お気に入り登録していないスポットは閲覧できません。')
          expect(response).to redirect_to(public_favorites_path)
        end
      end
    end

    describe "各アクションのテスト" do
      before do
        sign_in user
      end

      context 'indexのテスト' do
        it 'ログインユーザーが登録したお気に入りのみを表示' do
          get public_favorites_path
          expect(assigns(:favorites)).to eq([favorite])
        end
      end

      context 'createのテスト' do
        it 'お気に入り登録の確認' do
          expect { Favorite.create(user_id: user.id, spot_id: spot.id) }.to change(Favorite, :count).by(1)
        end
      end

      context 'showのテスト' do
        it 'コメント情報の更新' do
          expect(Spot.exists?(id: spot.id)).to eq(true)
        end
      end

      context 'destroyのテスト' do
        it 'コメントの削除「format: :js」' do
          expect { delete public_favorite_path(favorite, id: spot.id, format: :js) }.to change(Favorite, :count).by(-1)
          expect(flash.now[:alert] ).to eq("「#{spot.name}」をお気に入りから削除しました。")
        end

        it 'コメントの削除「format: :html」' do
          expect { delete public_favorite_path(favorite, id: spot.id, format: :html) }.to change(Favorite, :count).by(-1)
          expect(response).to redirect_to(public_favorites_path)
          expect(flash[:notice] ).to eq("「#{spot.name}」をお気に入り一覧から削除しました。")
        end
      end
    end
  end
end