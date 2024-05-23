# frozen_string_literal: true

require 'rails_helper'

describe 'userモデルのテスト' do
  it "有効なユーザー情報の場合は保存されるか" do
    expect(FactoryBot.build(:user)).to be_valid
  end
end