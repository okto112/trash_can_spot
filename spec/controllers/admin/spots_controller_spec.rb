# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SpotsController, type: :request do
  describe 'admin/spots_controllerのテスト' do
    let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
    let!(:user) { FactoryBot.create(:user) }
    let!(:test_user) { FactoryBot.create(:user) }
    let!(:kind) { FactoryBot.create(:kind) }
    let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }

    describe "before_actionのテスト" do
      context ':authenticate_admin!のテスト' do
        it "未サインインの場合" do
          get admin_root_path
          expect(response).to redirect_to(new_admin_session_path)
        end

        it "サインインの場合" do
          sign_in admin
          get admin_root_path
          expect(response).to be_successful
        end
      end

      context ':spot_findのテスト' do
        it "spotのデータを取得" do
          expect(Spot.exists?(spot.id)).to eq(true)
        end
      end

      context ':acquisition_all_kindのテスト' do
        it "kindのデータを取得" do
          expect(Kind.all.exists?).to eq(true)
        end
      end
    end

    describe "各アクションのテスト" do
      before do
        sign_in admin
      end

      context 'indexのテスト' do
        context 'キーワード検索のテスト' do
          it 'キーワードが一致した場合' do
            get admin_spots_path,params: { key_word: kind.name }
            expect(assigns(:spots)).to include(spot)
            expect(assigns(:kind)).to eq([kind])
            expect(flash.now[:alert]).to be_nil
            expect(assigns(:key_word)).to eq(kind.name)
            expect(assigns(:title)).to eq("スポット")
          end

          it 'キーワードが一致しなかった場合' do
            get admin_spots_path,params: { key_word: "test" }
            expect(assigns(:spots)).to eq([])
            expect(assigns(:kind)).to eq([])
            expect(flash.now[:alert]).to eq('該当するスポットは見つかりませんでした。')
            expect(assigns(:key_word)).to eq("test")
            expect(assigns(:title)).to eq("スポット")
          end
        end

        context 'ユーザー検索のテスト' do
          it '種類が一致した場合' do
            get admin_spots_path,params: { user_id: user.id }
            expect(assigns(:spots)).to include(spot)
            expect(flash.now[:alert]).to be_nil
            expect(assigns(:key_word)).to be_nil
            expect(assigns(:title)).to eq("#{user.name}さんのスポット")
          end

          it '種類が一致しなかった場合' do
            get admin_spots_path,params: { user_id: 2 }
            expect(assigns(:spots)).to eq([])
            expect(assigns(:key_word)).to be_nil
          end
        end
      end

      context 'updateのテスト' do
        it 'スポット情報の更新' do
          patch admin_spot_path(spot), params: { spot: { id: spot.id, user_id: user.id, name: '新しいスポット', introduction: spot.introduction, latitude: spot.introduction, longitude: spot.longitude, kind_ids: [kind.id] } }
          expect(response).to redirect_to(admin_spot_path(spot))
          expect(flash[:notice]).to eq("「新しいスポット」を編集しました！")
        end

        it 'スポット情報の更新に失敗した場合' do
          patch admin_spot_path(spot), params: { spot: { introduction: "" } }
          expect(response).to render_template(:edit)
          @spot = assigns(:spot)
          expect(@spot.errors.empty?).to eq(false)
        end
      end

      context 'destroyのテスト' do
        it 'スポットの削除' do
          delete admin_spot_path(spot)
          expect(response).to redirect_to(admin_spots_path)
          expect(flash[:notice]).to eq("「#{spot.name}」を削除しました。")
        end
      end
    end
  end
end