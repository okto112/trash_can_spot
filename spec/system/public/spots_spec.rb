# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Spots', type: :feature do

  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }

  before do
    login_as user
  end

  describe 'スポット登録画面の確認' do
    before do
      visit new_public_spot_path
    end

    it '登録画面の表示確認' do
      expect(page).to have_field 'spot[name]'
      expect(page).to have_field 'spot[introduction]'
      expect(page).to have_button 'スポットを登録する'
    end

    it '新規登録の確認' do
      fill_in 'spot[name]', with: 'test_spot', match: :first
      fill_in 'spot[introduction]', with: 'test_introduction', match: :first
      check 'spot[kind_ids][]', with: kind.id, match: :first
      click_on 'スポットを登録する', match: :first
      expect(current_path).to eq('/public/spots')
    end
  end

  describe 'スポット一覧画面の確認' do
    before do
      visit public_spots_path
    end

    it '一覧画面の表示確認' do
      expect(page).to have_content spot.created_at.strftime('%Y/%m/%d')
      expect(page).to have_content spot.name
      expect(page).to have_link '表示'
      expect(page).to have_link '削除'
    end

    it '一覧画面から詳細画面への遷移確認' do
      click_on '表示', match: :first
      expect(current_path).to eq("/public/spots/#{spot.id}")
    end

    it 'スポット削除の確認' do
      click_on '削除', match: :first
      expect(current_path).to eq("/public/spots")
    end
  end

  describe 'スポット詳細画面の確認' do
    before do
      visit public_spot_path(spot.id)
    end

    it '詳細画面の表示確認' do
      expect(page).to have_content spot.name
      expect(page).to have_content spot.introduction
      expect(page).to have_link '編集する'
    end

    it '詳細画面から編集への遷移確認' do
      click_on '編集する', match: :first
      expect(current_path).to eq("/public/spots/#{spot.id}/edit")
    end
  end

  describe 'スポット編集画面の確認' do
    before do
      visit edit_public_spot_path(spot.id)
    end

    it '編集画面の表示確認' do
      expect(page).to have_field 'spot[name]', with: spot.name
      expect(page).to have_field 'spot[introduction]', with: spot.introduction
      expect(page).to have_button '変更内容を保存'
    end

    it '編集情報の保存確認' do
      fill_in 'spot[name]', with: 'new_spot', match: :first
      fill_in 'spot[introduction]', with: 'new_introduction', match: :first
      check 'spot[kind_ids][]', with: kind.id, match: :first
      click_on '変更内容を保存', match: :first
      expect(current_path).to eq("/public/spots/#{spot.id}")
    end
  end
end