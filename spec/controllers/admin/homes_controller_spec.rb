# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::HomesController, type: :request do
  describe 'admin/homes_controllerのテスト' do
    let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
    let!(:user) { FactoryBot.create(:user) }
    let!(:test_user) { FactoryBot.create(:user) }
    let!(:kind) { FactoryBot.create(:kind) }
    let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }
    let!(:comment) { FactoryBot.create(:comment, user_id: user.id, spot_id: spot.id) }

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
    end

    describe "topアクションのテスト" do
      before do
        sign_in admin
      end

      it "データを全取得" do
        expect(Spot.all.exists?).to eq(true)
        expect(Comment.all.exists?).to eq(true)
        expect(Kind.all.exists?).to eq(true)
      end
    end
  end
end