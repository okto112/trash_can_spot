# frozen_string_literal: true

require 'rails_helper'

describe 'ユーザーテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示の確認' do
      it 'トップ画面に新規登録ページへのリンクが表示されているか' do
        expect(page).to have_link "新規登録", href: new_user_registration_path
      end
      it 'トップ画面にログインページへのリンクが表示されているか' do
        expect(page).to have_link "ログイン", href: new_user_session_path
      end
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
    end
  end
  describe '新規登録画面のテスト' do
    before do
      visit new_user_registration_path
    end
    context '表示の確認' do
      it 'new_user_registration_pathが"/users/sign_up"であるか' do
        expect(current_path).to eq('/users/sign_up')
      end
      it '新規登録ボタンが表示されているか' do
        expect(page).to have_button '新規登録'
      end
    end
  end
end