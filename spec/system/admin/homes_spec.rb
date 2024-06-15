# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'homes', type: :feature do
  let!(:admin) { Admin.create(email: 'test@example.com', password: 'test') }

  before do
    login_as(admin, scope: :admin)
  end

  describe 'トップ画面の確認' do
    it '表示確認' do
      visit admin_root_path
      marker = find("#map", visible: false)
      marker.click
      expect(page).to have_selector('#spot-info', visible: true)
    end
  end
end