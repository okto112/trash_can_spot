# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::UsersController, type: :request do
  describe 'public/users_controllerのテスト' do
    let(:test_user) { FactoryBot.create(:user) }

    describe "before_actionのテスト" do
      context ':authenticate_user!のテスト' do
        it "未サインインの場合" do
          get public_users_my_page_path
          expect(response).to redirect_to(new_user_session_path)
        end

        it "サインインの場合" do
          sign_in test_user

          get public_users_my_page_path
          expect(response).to be_successful
        end
      end
    end

    describe "各アクションのテスト" do
      context 'showのテスト' do
        it 'ユーザー情報の確認' do
          sign_in test_user
          get public_users_my_page_path
          expect(response).to be_successful
          expect(assigns(:user)).to eq(test_user)
        end
      end

      context 'editのテスト' do
        it '編集画面の表示' do
          sign_in test_user
          get public_users_information_edit_path
          expect(response).to be_successful
          expect(assigns(:user)).to eq(test_user)
        end
      end

      context 'updateのテスト' do
        it 'ユーザー情報の更新' do
          sign_in test_user
          patch public_users_information_path, params: { user: { name: '新しい名前' } }
          expect(response).to redirect_to(public_users_my_page_path)
          expect(flash[:notice]).to eq('ユーザー情報を編集しました!')
          test_user.reload
          expect(test_user.name).to eq('新しい名前')
        end

        it 'ユーザー情報の更新に失敗した場合' do
          sign_in test_user
          patch public_users_information_path, params: { user: { name: '' } }
          expect(response).to render_template(:edit)
          test_user.reload
          expect(test_user.name).not_to eq('')
        end
      end

      context 'unsubscribeのテスト' do
        it '退会確認画面の表示' do
          sign_in test_user
          get public_users_unsubscribe_path
          expect(response).to be_successful
          expect(assigns(:user)).to eq(test_user)
        end
      end

      context 'withdrawのテスト' do
        it '正常なリクエストの場合、ユーザーがゴミ箱スポットから退会し、ルートページにリダイレクトされること' do
          sign_in test_user
          invalid_params = { name: test_user.name, email: test_user.email, is_active: test_user.is_active }
          patch public_users_withdraw_path, params: { user: invalid_params }
          sign_in test_user # サインインし直す
          expect(response).to redirect_to(root_path)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('ゴミ箱スポットから退会しました。')
          expect(test_user.reload.persisted?).to eq(false)
        end

        it '無効なリクエストの場合、編集ページが再表示されること' do
          sign_in test_user
          invalid_params = { name: '' } # 無効なパラメータを作成する必要があります
          patch public_users_withdraw_path, params: { user: invalid_params }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(200) # 正常に編集ページが表示されることを確認します
        end
      end
    end
  end
end