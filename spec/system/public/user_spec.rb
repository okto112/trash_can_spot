# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Users', type: :feature do
  before do
    @user = User.create(
      name: 'TEST_USER',
      email: 'test@example.com',
      password: 'password1234',
    )
  end
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
end