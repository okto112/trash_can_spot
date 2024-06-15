# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Favorites', type: :feature do

  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }
  let!(:favorite) { Favorite.create(user_id: user.id, spot_id: spot.id) }

  before do
    login_as user
  end

  describe 'お気に入りスポット一覧画面の確認' do
    before do
      visit public_favorites_path
    end

    it '一覧画面の表示確認' do
      expect(page).to have_content spot.name
      expect(page).to have_content spot.introduction
      expect(page).to have_link '表示'
      expect(page).to have_link '削除'
    end

    it '一覧画面から詳細画面への遷移確認' do
      click_on '表示'
      expect(current_path).to eq("/public/favorites/#{spot.id}")
    end

    it 'お気に入り削除の確認' do
      click_on '削除'
      expect(current_path).to eq("/public/favorites")
    end
  end

  describe 'お気に入りスポット詳細画面の確認' do
    before do
      visit public_favorite_path(spot.id)
    end

    it '詳細画面の表示確認' do
      expect(page).to have_content spot.name
      expect(page).to have_content spot.introduction
      expect(page).to have_link '編集する'
    end

    it '詳細画面から編集への遷移確認' do
      click_on '編集する'
      expect(current_path).to eq("/public/spots/#{spot.id}/edit")
    end
  end
end