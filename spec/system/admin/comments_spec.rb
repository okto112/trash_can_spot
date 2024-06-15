# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Comments', type: :feature do
  let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }
  let!(:user) { FactoryBot.create(:user) }
  let!(:kind) { FactoryBot.create(:kind) }
  let!(:spot) { FactoryBot.create(:spot, user_id: user.id, kind_ids: [kind.id]) }
  let!(:comment) { FactoryBot.create(:comment, user_id: user.id, spot_id: spot.id) }

  before do
    login_as(admin, scope: :admin)
  end

  describe 'コメント一覧画面の確認' do
    it '一覧画面の表示確認' do
      visit admin_comments_path
      expect(page).to have_content comment.created_at.strftime('%Y/%m/%d')
      expect(page).to have_content Spot.find(comment.spot_id).name
      expect(page).to have_content comment.comment
      expect(page).to have_link '表示'
      expect(page).to have_link '削除'
    end
  end

  describe 'コメント詳細画面の確認' do
    it '詳細画面の表示確認' do
      visit admin_comment_path(spot.id)
      expect(page).to have_content comment.comment
      expect(page).to have_link '編集する'
    end
  end

  describe 'コメント編集画面の確認' do
    it '編集画面の表示確認' do
      visit edit_admin_comment_path(comment.id)
      expect(page).to have_field 'comment[comment]', with: comment.comment
      expect(page).to have_button '変更内容を保存'
    end
  end
end