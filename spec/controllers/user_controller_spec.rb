# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Public::UsersController, type: :request do
  describe 'public/users_controllerのテスト' do
    describe "before_actionのテスト" do
      context ':authenticate_user!のテスト' do
        it "redirects to the sign in page if user is not authenticated" do
          get public_users_my_page_path
          expect(response).to redirect_to(new_user_session_path)
        end

        it "returns success response if user is authenticated" do
          user = create(:user)
          sign_in user

          get public_users_my_page_path
          expect(response).to be_successful
        end
      end
    end
  end
end