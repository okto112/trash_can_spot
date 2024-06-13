# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Comments', type: :feature do

  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }
  let!(:comment) { FactoryBot.create(:comment, user_id: user.id, spot_id: spot.id) }

  before do
    login_as user
  end

  describe 'コメント投稿画面の確認' do
    before do
      visit new_public_comment_path(spot_id: spot.id)
    end

    it '投稿画面の表示確認' do
      expect(page).to have_field 'comment[comment]'
      expect(page).to have_button 'コメントを投稿する'
    end

    it '新規投稿の確認' do
      fill_in 'comment[comment]', with: 'test_comment'
      click_on 'コメントを投稿する'
      expect(current_path).to eq('/public/comments')
    end
  end

  describe 'コメント一覧画面の確認' do
    before do
      visit public_comments_path
    end

    it '一覧画面の表示確認' do
      expect(page).to have_content comment.created_at.strftime('%Y/%m/%d')
      expect(page).to have_content Spot.find(comment.spot_id).name
      expect(page).to have_content comment.comment
      expect(page).to have_link '表示'
      expect(page).to have_link '削除'
    end

    it '一覧画面から詳細画面への遷移確認' do
      click_on '表示'
      expect(current_path).to eq("/public/comments/#{comment.id}")
    end

    it 'コメント削除の確認' do
      click_on '削除'
      expect(current_path).to eq("/public/comments")
    end
  end

  describe 'コメント詳細画面の確認' do
    before do
      visit public_comment_path(spot.id)
    end

    it '詳細画面の表示確認' do
      expect(page).to have_content comment.comment
      expect(page).to have_link '編集する'
    end

    it '詳細画面から編集への遷移確認' do
      click_on '編集する'
      expect(current_path).to eq("/public/comments/#{comment.id}/edit")
    end
  end

  describe 'スポット編集画面の確認' do
    before do
      visit edit_public_comment_path(comment.id)
    end

    it '編集画面の表示確認' do
      expect(page).to have_field 'comment[comment]', with: comment.comment
      expect(page).to have_button '変更内容を保存'
    end

    it '編集情報の保存確認' do
      visit edit_public_comment_path(comment.id)
      fill_in 'comment[comment]', with: 'new_comment'
      click_on '変更内容を保存'
      expect(current_path).to eq("/public/comments/#{comment.id}")
    end
  end
end