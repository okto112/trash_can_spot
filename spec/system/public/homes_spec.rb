# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'homes', type: :feature do

  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }

  before do
    login_as user
  end

  describe 'トップ画面の確認' do
    before do
      visit root_path
    end

    it '表示確認' do
      expect(page).to have_link '新規登録'
      expect(page).to have_link 'ログイン'
    end
  end

  describe 'メイン画面の確認' do
    before do
      visit public_main_path
    end

    it '表示確認' do
      expect(page).to have_content '種類検索：'
      expect(page).to have_link 'すべて'
      expect(page).to have_link "#{kind.name}"
      expect(page).to have_selector('form[action="' + public_main_path + '"][method="get"]')
      expect(page).to have_button '検索'
      expect(page).to have_field('address', type: 'textbox', placeholder: '地図検索')
      expect(page).to have_button '検索'
      expect(page).to have_content 'スポット情報'
    end

    it 'マップのマーカー動作確認' do
      marker = find("#map", visible: true)
      marker.click
      expect(page).to have_selector('#spot-info', visible: true)
    end
  end
end