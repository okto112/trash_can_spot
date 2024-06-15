# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::HomesController, type: :request do
  describe 'public/homes_controllerのテスト' do
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

      context ':all_data_acquisitionのテスト' do
        it "データを全取得" do
          expect(Spot.all.exists?).to eq(true)
          expect(Comment.all.exists?).to eq(true)
          expect(Kind.all.exists?).to eq(true)
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
    end

    describe "mainアクションのテスト" do
      before do
        sign_in user
      end

      context 'キーワード検索のテスト' do
        it 'キーワードが一致した場合' do
          get public_main_path,params: { key_word: spot.name }
          expect(assigns(:spots)).to include(spot)
          expect(flash.now[:alert]).to be_nil
          expect(assigns(:key_word)).to eq(spot.name)
          expect(assigns(:kind_id)).to eq(0)
        end

        it 'キーワードが一致しなかった場合' do
          get public_main_path,params: { key_word: "test" }
          expect(assigns(:spots)).to eq([])
          expect(flash.now[:alert]).to eq('該当するスポットは見つかりませんでした。')
          expect(assigns(:key_word)).to eq("test")
          expect(assigns(:kind_id)).to eq(0)
        end
      end

      context '種類検索のテスト' do
        it 'すべてを選択した場合' do
          get public_main_path(kind_id: 0)
          expect(assigns(:spots)).to include(spot)
          expect(flash.now[:alert]).to be_nil
          expect(assigns(:kind_id)).to eq(0)
        end

        it '種類が一致した場合' do
          get public_main_path,params: { kind_id: kind.id }
          expect(assigns(:spots)).to include(spot)
          expect(flash.now[:alert]).to be_nil
          expect(assigns(:kind_id)).to eq("#{kind.id}")
        end

        it '種類が一致しなかった場合' do
          get public_main_path,params: { kind_id: 2 }
          expect(assigns(:spots)).to eq([])
          expect(flash.now[:alert]).to eq('該当するスポットは見つかりませんでした。')
          expect(assigns(:kind_id)).to eq("2")
        end
      end
    end
  end
end