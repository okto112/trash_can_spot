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

  describe 'ゴミの種類作成画面の確認' do
    it '作成画面の表示確認' do
      visit new_admin_kind_path
      expect(page).to have_field 'kind[name]'
      expect(page).to have_content 'White'
      expect(page).to have_content 'Gray'
      expect(page).to have_content 'Red'
      expect(page).to have_content 'Purple'
      expect(page).to have_content 'blue'
      expect(page).to have_content 'Yellow'
      expect(page).to have_content 'Green'
      expect(page).to have_content 'Orange'
      expect(page).to have_content 'Pink'
      expect(page).to have_content 'Brown'
      expect(page).to have_button "ゴミの種類を追加する"
    end
  end

  describe 'ゴミの種類一覧画面の確認' do
    it '一覧画面の表示確認' do
      visit admin_kinds_path
      expect(page).to have_content kind.name
      expect(page).to have_link "編集"
      expect(page).to have_link "削除"
    end
  end

  describe 'ゴミの種類編集画面の確認' do
    it '編集画面の表示確認' do
      visit edit_admin_kind_path(kind.id)
      expect(page).to have_field 'kind[name]'
      expect(page).to have_content 'White'
      expect(page).to have_content 'Gray'
      expect(page).to have_content 'Red'
      expect(page).to have_content 'Purple'
      expect(page).to have_content 'blue'
      expect(page).to have_content 'Yellow'
      expect(page).to have_content 'Green'
      expect(page).to have_content 'Orange'
      expect(page).to have_content 'Pink'
      expect(page).to have_content 'Brown'
      expect(page).to have_button "変更内容を保存"
    end
  end
end