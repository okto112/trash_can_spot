# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザー登録のテスト' do
  describe 'トップ画面(root_path)のテスト' do
    before do
      visit root_path
    end
    context '表示の確認' do
      it 'トップ画面(root_path)に一覧ページへのリンクが表示されているか' do
        expect(page).to have_link "新規登録", href: new_user_registration_path
      end
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
    end
  end
end