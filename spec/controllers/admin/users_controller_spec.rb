# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::UsersController, type: :request do
  describe 'admin/users_controllerのテスト' do
    let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
    let!(:user) { FactoryBot.create(:user) }
    let!(:guest_user) { User.guest }

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

      context ':user_findのテスト' do
        it "spotのデータを取得" do
          expect(User.exists?(user.id)).to eq(true)
        end
      end

      context ':edit_guest_userのテスト' do
        it "ゲストユーザーの情報は編集できないことを確認" do
          sign_in admin
          get edit_admin_user_path(guest_user.id)
          expect(response).to redirect_to(admin_user_path(guest_user.id))
          expect(flash[:notice]).to eq('ゲストユーザーはユーザー情報を編集できません。')
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
            get admin_users_path,params: { key_word: user.name }
            expect(assigns(:users)).to include(user)
            expect(flash.now[:alert]).to be_nil
            expect(assigns(:key_word)).to eq(user.name)
          end

          it 'キーワードが一致しなかった場合' do
            get admin_users_path,params: { key_word: "notuser" }
            expect(assigns(:users)).to include()
            expect(flash.now[:alert]).to eq('該当するユーザーは見つかりませんでした。')
            expect(assigns(:key_word)).to eq("notuser")
          end
        end
      end

      context 'updateのテスト' do
        it 'ユーザー情報の更新' do
          patch admin_user_path(user.id), params: { user: { name: '新しい名前' } }
          expect(response).to redirect_to(admin_user_path(user.id))
          expect(flash[:notice]).to eq("「新しい名前」さんを編集しました!")
          user.reload
          expect(user.name).to eq('新しい名前')
        end

        it 'ユーザー情報の更新に失敗した場合' do
          patch admin_user_path(user.id), params: { user: { name: '' } }
          expect(response).to render_template(:edit)
          user.reload
          expect(user.name).not_to eq('')
        end
      end
    end
  end
end