# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }

  before do
    login_as(admin, scope: :admin)
  end

  describe 'ユーザー一覧画面の確認' do
    it '一覧画面の表示確認' do
      visit admin_users_path
      expect(page).to have_content user.id
      expect(page).to have_link user.name
      expect(page).to have_content "有効"
    end
  end

  describe 'ユーザー詳細画面の確認' do
    it '詳細画面の表示確認' do
      visit admin_user_path(user.id)
      expect(page).to have_content user.id
      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content "有効"
    end
  end

  describe 'ユーザー編集画面の確認' do
    it '編集画面の表示確認' do
      visit edit_admin_user_path(user.id)
      expect(page).to have_field 'user[name]', with: user.name
      expect(page).to have_field 'user[email]', with: user.email
      expect(page).to have_button '変更内容を保存'
    end
  end
end