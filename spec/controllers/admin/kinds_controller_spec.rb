# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SpotsController, type: :request do
  describe 'admin/spots_controllerのテスト' do
    let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
    let!(:user) { FactoryBot.create(:user) }
    let!(:test_user) { FactoryBot.create(:user) }
    let!(:kind) { FactoryBot.create(:kind) }
    let!(:test_kind) { FactoryBot.create(:kind) }
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

      context ':kind_findのテスト' do
        it "spotのデータを取得" do
          expect(Kind.exists?(kind.id)).to eq(true)
        end
      end
    end

    describe "各アクションのテスト" do
      before do
        sign_in admin
      end

      context 'indexのテスト' do
        it 'ログインユーザーが作成したスポットのみを表示' do
          get admin_kinds_path
          expect(Kind.all.exists?).to eq(true)
          expect(assigns(:kinds)).to eq([kind, test_kind])
        end
      end

      context 'newのテスト' do
        it 'ゴミの種類作成の確認' do
          get new_admin_kind_path
          expect(assigns(:kind)).to be_a_new(Kind)
        end
      end

      context 'createのテスト' do
        it 'ゴミの種類作成できた場合' do
          post admin_kinds_path, params: { kind: { name: kind.name, color: kind.color } }
          expect(flash[:notice]).to eq("「#{kind.name}」を追加しました!")
          expect(response).to redirect_to(admin_kinds_path)
        end

        it "ゴミの種類作成できなかった場合" do
          post admin_kinds_path, params: { kind: { name: kind.name, color: '' } }
          expect(response).to render_template(:new)
        end
      end

      context 'updateのテスト' do
        it 'ゴミの種類情報の更新' do
          patch admin_kind_path(kind), params: { kind: { id: kind.id, name: '新しいスポット', color: kind.color } }
          expect(response).to redirect_to(admin_kinds_path)
          expect(flash[:notice]).to eq("「新しいスポット」を編集しました!")
        end

        it 'ゴミの種類情報の更新に失敗した場合' do
          patch admin_kind_path(kind), params: { kind: { name: "" } }
          expect(response).to render_template(:edit)
        end
      end

      context 'destroyのテスト' do
        it 'ゴミの種類の削除' do
          delete admin_kind_path(test_kind)
          expect(response).to redirect_to(admin_kinds_path)
          expect(flash[:notice]).to eq("「#{kind.name}」を削除しました。")
        end

        it 'ゴミの種類の削除ができない場合' do
          delete admin_kind_path(kind)
          expect(response).to redirect_to(admin_kinds_path)
          expect(flash[:alert]).to eq("「#{kind.name}」はスポットで使用されている為、削除できませんでした。")
        end
      end
    end
  end
end