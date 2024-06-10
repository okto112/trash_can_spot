# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::SpotsController, type: :request do
  describe 'public/users_controllerのテスト' do
    let(:user) { FactoryBot.create(:user) }
    let(:test_user) { FactoryBot.create(:user) }
    let(:kind) { FactoryBot.create(:kind) }
    let(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }

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

      context ':acquisition_all_kindのテスト' do
        it "kindのデータを取得" do
          expect(Kind.all.exists?).to eq(false)
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
        it "spotのデータを取得" do
          expect(Spot.all.exists?).to eq(false)
        end

        it "ログインユーザーが作成したスポットではない場合" do
          sign_in test_user
          get edit_public_spot_path(spot), params: { id: spot.id }
          expect(flash[:alert]).to eq('他のユーザーが登録したスポットの詳細閲覧・編集はできません。')
          expect(response).to redirect_to(public_spots_path)
        end
      end

      context ':check_destroy_spotのテスト' do
        it "ログインユーザーが作成したスポットではない場合" do
          sign_in test_user
          delete public_spot_path(spot), params: { id: spot.id }
          expect(flash[:alert]).to eq('他のユーザーが登録したスポットは削除できません。')
          expect(response).to redirect_to(public_spots_path)
        end
      end
    end

    describe "各アクションのテスト" do
      context 'indexのテスト' do
        it 'ログインユーザーが作成したスポットのみを表示' do
          sign_in user
          get public_spots_path, params: { spot: spot.attributes }
          expect(assigns(:spots)).to eq([spot])
        end
      end

      context 'newのテスト' do
        it 'スポット作成の確認' do
          sign_in user
          get new_public_spot_path
          expect(assigns(:spot)).to be_a_new(Spot)
        end
      end

      context 'createのテスト' do
        it 'スポット作成の確認' do
          sign_in user
          post public_spots_path, params: { spot: { user_id: user.id, name: spot.name, introduction: spot.introduction, latitude: spot.introduction, longitude: spot.longitude, kind_ids: [kind.id] } }
          expect(flash[:notice]).to eq("「#{spot.name}」を登録しました！")
          expect(response).to redirect_to(public_spots_path)
        end

        it "SpotKindのエラー確認" do
          sign_in user
          post public_spots_path, params: { spot: { introduction: "説明文" } }
          @spot = assigns(:spot)
          expect(@spot.errors.empty?).to eq(false)
        end
      end

      context 'updateのテスト' do
        it 'スポット情報の更新' do
          sign_in user
          patch public_spot_path(spot), params: { spot: { id: spot.id, user_id: user.id, name: '新しいスポット', introduction: spot.introduction, latitude: spot.introduction, longitude: spot.longitude, kind_ids: [kind.id] } }
          expect(response).to redirect_to(public_spot_path(spot))
          expect(flash[:notice]).to eq("「新しいスポット」を編集しました！")
        end

        it 'スポット情報の更新に失敗した場合' do
          sign_in user
          patch public_spot_path(spot), params: { spot: { introduction: "" } }
          expect(response).to render_template(:edit)
          @spot = assigns(:spot)
          expect(@spot.errors.empty?).to eq(false)
        end
      end

      context 'destroyのテスト' do
        it 'スポットの削除' do
          sign_in user
          delete public_spot_path(spot)
          expect(response).to redirect_to(public_spots_path)
          expect(flash[:notice]).to eq("「#{spot.name}」を削除しました。")
        end
      end
    end
  end
end