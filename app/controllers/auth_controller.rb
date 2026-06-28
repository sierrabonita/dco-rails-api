# frozen_string_literal: true

# ユーザーの認証処理（ログイン、ログアウト、トークンのリフレッシュ）を行うコントローラ
class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login logout refresh]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token, refresh_token = generate_tokens(user)
      user.update(refresh_token: refresh_token)

      render json: auth_response_json(user, access_token, refresh_token), status: :ok
    else
      render json: { error: 'メールアドレスまたはパスワードが正しくありません' }, status: :unauthorized
    end
  end

  # リフレッシュトークンを使って新しいアクセストークンを発行する
  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])

    if user
      access_token, new_refresh_token = generate_tokens(user)
      user.update(refresh_token: new_refresh_token)

      render json: auth_response_json(user, access_token, new_refresh_token), status: :ok
    else
      render json: { error: '無効なリフレッシュトークンです' }, status: :unauthorized
    end
  end

  def logout
    # アクセストークンによる認証が通っていれば @current_user が存在する
    if @current_user
      @current_user.update(refresh_token: nil)
    elsif params[:refresh_token]
      user = User.find_by(refresh_token: params[:refresh_token])
      user&.update(refresh_token: nil)
    end
    render(json: { message: 'ログアウトしました' }, status: :ok)
  end

  private

  def generate_tokens(user)
    # アクセストークンは有効期限を短く設定（例：15分）
    access_token = JsonWebToken.encode({ user_id: user.id, role: user.role, exp: 15.minutes.from_now.to_i })
    refresh_token = SecureRandom.urlsafe_base64
    [access_token, refresh_token]
  end

  def auth_response_json(user, access_token, refresh_token)
    {
      access_token: access_token,
      refresh_token: refresh_token,
      user: {
        id: user.id,
        email: user.email,
        role: user.role
      }
    }
  end
end
