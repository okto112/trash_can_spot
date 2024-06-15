# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::UsersController, type: :request do
  describe 'public/users_controllerのテスト' do
    let(:test_user) { FactoryBot.create(:user) }
    let(:guest_user) { User.guest }

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

      context ':edit_guest_userのテスト' do
        it "ゲストユーザーの情報は編集できないことを確認" do
          sign_in guest_user
          get public_users_information_edit_path
          expect(response).to redirect_to(public_users_my_page_path)
          expect(flash[:alert]).to eq('ゲストユーザーはユーザー情報を編集できません。')
        end
      end

      context ':withdrawal_guest_userのテスト' do
        it "ゲストユーザーは退会確認画面に遷移できないことを確認" do
          sign_in guest_user
          get public_users_unsubscribe_path
          expect(response).to redirect_to(public_users_my_page_path)
          expect(flash[:alert]).to eq('ゲストユーザーは退会できません。')
        end

        it "ゲストユーザーは退会できないことを確認" do
          sign_in guest_user
          valid_params = { is_active: false }
          patch public_users_withdraw_path, params: { user: valid_params }
          expect(response).to redirect_to(public_users_my_page_path)
          expect(flash[:alert]).to eq('ゲストユーザーは退会できません。')
        end
      end

      context ':check_active_userのテスト' do
        it "ログイン中にis_activeがfalseになるとログアウトするかを確認" do
          sign_in test_user
          test_user.is_active = false
          get public_users_my_page_path
          sign_out test_user
          expect(response).to redirect_to(root_path)
          expect(flash[:alert]).to eq('先程のアカウントは管理者より使用できなくなりました。')
        end
      end
    end

    describe "各アクションのテスト" do
      before do
        sign_in test_user
      end

      context 'showのテスト' do
        it 'ユーザー情報の確認' do
          get public_users_my_page_path
          expect(response).to be_successful
          expect(assigns(:user)).to eq(test_user)
        end
      end

      context 'editのテスト' do
        it '編集画面の表示' do
          get public_users_information_edit_path
          expect(response).to be_successful
          expect(assigns(:user)).to eq(test_user)
        end
      end

      context 'updateのテスト' do
        it 'ユーザー情報の更新' do
          patch public_users_information_path, params: { user: { name: '新しい名前' } }
          expect(response).to redirect_to(public_users_my_page_path)
          expect(flash[:notice]).to eq('ユーザー情報を編集しました!')
          test_user.reload
          expect(test_user.name).to eq('新しい名前')
        end

        it 'ユーザー情報の更新に失敗した場合' do
          patch public_users_information_path, params: { user: { name: '' } }
          expect(response).to render_template(:edit)
          test_user.reload
          expect(test_user.name).not_to eq('')
        end
      end

      context 'unsubscribeのテスト' do
        it '退会確認画面の表示' do
          get public_users_unsubscribe_path
          expect(response).to be_successful
          expect(assigns(:user)).to eq(test_user)
        end
      end

      context 'withdrawのテスト' do
        it 'ユーザーの退会処理' do
          valid_params = { is_active: false }
          patch public_users_withdraw_path, params: { user: valid_params }
          expect(response).to redirect_to(root_path)
          expect(response).to have_http_status(302)
          expect(flash[:notice]).to eq('ゴミ箱スポットから退会しました。')
          expect(test_user.reload.is_active).to eq(false)
        end

        it '無効なリクエストの場合、編集ページが再表示されること' do
          invalid_params = { name: '' }
          patch public_users_withdraw_path, params: { user: invalid_params }
          expect(response).to render_template(:edit)
          expect(response).to have_http_status(200)
        end
      end
    end
  end
end