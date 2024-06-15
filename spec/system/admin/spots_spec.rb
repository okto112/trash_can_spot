# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Spots', type: :feature do
  let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }

  before do
    login_as(admin, scope: :admin)
  end

  describe 'スポット一覧画面の確認' do
    it '一覧画面の表示確認' do
      visit admin_spots_path
      expect(page).to have_content user.name
      expect(page).to have_content spot.name
      expect(page).to have_link '表示'
      expect(page).to have_link '削除'
    end
  end

  describe 'スポット詳細画面の確認' do
    it '詳細画面の表示確認' do
      visit admin_spot_path(spot.id)
      expect(page).to have_content spot.name
      expect(page).to have_content spot.introduction
      expect(page).to have_link '編集する'
    end
  end

  describe 'スポット編集画面の確認' do
    it '編集画面の表示確認' do
      visit edit_admin_spot_path(spot.id)
      expect(page).to have_field 'spot[name]', with: spot.name
      expect(page).to have_field 'spot[introduction]', with: spot.introduction
      expect(page).to have_button '変更内容を保存'
    end
  end
end