# frozen_string_literal: true

require 'rails_helper'

RSpec.describe('Users', type: :request) do
  let!(:user) { create(:user) }

  # ApplicationControllerで設定されている JWT 認証用のヘッダー
  let(:headers) do
    token = JsonWebToken.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  describe 'GET /users' do
    # ログインユーザー以外にもう1人作成しておく
    let!(:other_user) { create(:user) }

    it 'ユーザー一覧が取得できること' do
      get users_path, headers: headers, as: :json
      expect(response).to(have_http_status(:success))

      json = response.parsed_body
      expect(json.length).to(eq(2)) # ログインユーザーとother_userの2件
    end
  end

  describe 'GET /users/:id' do
    it 'ユーザー詳細が取得できること' do
      get user_path(user), headers: headers, as: :json
      expect(response).to(have_http_status(:success))

      json = response.parsed_body
      expect(json['id']).to(eq(user.id))
      expect(json['email']).to(eq(user.email))
      expect(json['name']).to(eq(user.name))
    end
  end

  describe 'POST /users' do
    context '有効なパラメータの場合' do
      let(:valid_params) do
        {
          user: {
            name: 'New User',
            email: 'newuser@example.com',
            password: 'password123'
          }
        }
      end

      it 'ユーザーが作成されること' do
        expect do
          post(users_path, params: valid_params, headers: headers, as: :json)
        end.to(change(User, :count).by(1))

        expect(response).to(have_http_status(:created))
      end
    end

    context '無効なパラメータの場合' do
      let(:invalid_params) { { user: { name: '', email: 'invalid_email' } } }

      it 'ユーザーが作成されないこと' do
        expect do
          post(users_path, params: invalid_params, headers: headers, as: :json)
        end.not_to(change(User, :count))

        expect(response).to(have_http_status(:unprocessable_content))
      end
    end
  end

  describe 'PATCH /users/:id' do
    context '有効なパラメータの場合' do
      let(:valid_params) { { user: { name: 'Updated Name' } } }

      it 'ユーザーが更新されること' do
        patch user_path(user), params: valid_params, headers: headers, as: :json
        expect(response).to(have_http_status(:success))

        user.reload
        expect(user.name).to(eq('Updated Name'))
      end
    end
  end

  describe 'DELETE /users/:id' do
    it 'ユーザーが削除されること' do
      expect { delete(user_path(user), headers: headers, as: :json) }.to(change(
        User,
        :count
      ).by(-1))

      expect(response).to(have_http_status(:no_content))
    end
  end
end
