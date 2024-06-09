# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Spot, type: :model do
  describe 'favoriteテーブルにログインユーザーのuser_idがあるか確認' do
    let(:test_user) { FactoryBot.create(:user) }
    let(:kind) { FactoryBot.create(:kind) }
    let(:spot) { FactoryBot.create(:spot, kind_ids: [kind.id]) }

    it 'user_idがない場合' do
      expect(spot.favorites.where(user_id: test_user.id).exists?).to eq(false)
    end

    it 'user_idがある場合' do
      Favorite.create(user_id: test_user.id, spot_id: spot.id)
      expect(spot.favorites.where(user_id: test_user.id).exists?).to eq(true)
    end
  end
end