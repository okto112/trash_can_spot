# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  let!(:user) { FactoryBot.create(:user,name: 'TEST_USER', email: 'test@example.com', password: 'password1234', ) }

  it '新規登録の確認' do
    visit new_user_registration_path
    fill_in 'ユーザー名', with: '太郎'
    fill_in 'メールアドレス', with: 'tarou@example.com'
    fill_in 'パスワード', with: 'tarou1234'
    fill_in 'パスワード(確認)', with: 'tarou1234'
    click_on '新規登録'
    expect(current_path).to eq('/public/users/my_page')
  end

  it 'ログインの確認' do
    visit new_user_session_path
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: 'password1234'
    click_on 'ログイン'
    expect(current_path).to eq('/public/main')
  end

  it 'ゲストログインの確認' do
    visit new_user_session_path
    click_on 'ゲストログイン'
    expect(current_path).to eq('/public/main')
  end

  describe '各アクションの確認' do
    before do
      login_as user
    end

    describe 'ユーザー詳細画面の確認' do
      before do
        visit public_users_my_page_path
      end

      it '詳細画面の表示確認' do
        expect(page).to have_content user.name
        expect(page).to have_content user.email
        expect(page).to have_link 'ユーザー情報を編集する'
        expect(page).to have_link '登録したスポットを見る'
        expect(page).to have_link '投稿したコメントを見る'
        expect(page).to have_link '退会する'
      end

      it '詳細画面から編集への遷移確認' do
        click_on 'ユーザー情報を編集する'
        expect(current_path).to eq("/public/users/information/edit")
      end

      it '詳細画面からスポット画面への遷移確認' do
        click_on '登録したスポットを見る'
        expect(current_path).to eq("/public/spots")
      end

      it '詳細画面からコメント画面への遷移確認' do
        click_on '投稿したコメントを見る'
        expect(current_path).to eq("/public/comments")
      end

      it '詳細画面から退会確認ト画面への遷移確認' do
        click_on '退会する'
        expect(current_path).to eq("/public/users/unsubscribe")
      end
    end

    describe 'ユーザー編集画面の確認' do
      before do
        visit public_users_information_edit_path
      end

      it '編集画面の表示確認' do
        expect(page).to have_field 'user[name]', with: user.name
        expect(page).to have_field 'user[email]', with: user.email
        expect(page).to have_button '変更内容を保存'
      end

      it '編集情報の保存確認' do
        fill_in 'user[name]', with: 'new_name'
        fill_in 'user[email]', with: 'new_email@example.com'
        click_on '変更内容を保存'
        expect(current_path).to eq("/public/users/my_page")
      end
    end

    describe '退会確認画面の確認' do
      before do
        visit public_users_unsubscribe_path
      end

      it '編集画面の表示確認' do
        expect(page).to have_link '退会しない'
        expect(page).to have_button '退会する'
      end

      it '退会しない場合' do
        click_on '退会しない'
        expect(current_path).to eq("/public/users/my_page")
      end

      it '退会した場合' do
        click_on '退会する'
        expect(current_path).to eq("/")
      end
    end
  end
end