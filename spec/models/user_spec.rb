# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ゲストユーザーの作成テスト' do
    let(:guest_user) { User.guest }

    it 'self.guestメソッドの動作確認' do
      expect(guest_user).to be_a(User)
    end

    it 'ゲストユーザーが存在しなかった場合' do
      expect{guest_user}.to change(User, :count).by(1)
    end

    it 'ゲストユーザーが存在していた場合' do
      expect(guest_user).to eq(guest_user)
    end

    it 'ゲストユーザーの情報が正しいか' do
      expect(guest_user.name).to eq('ゲストユーザー')
      expect(guest_user.email).to eq(User::GUEST_USER_EMAIL)
    end
  end

  describe 'userのテスト' do
    it "正しくユーザー情報が保存されるか" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end
end