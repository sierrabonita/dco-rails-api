# frozen_string_literal: true

class AuthController < ApplicationController
  skip_before_action :authenticate_request, only: [:login, :refresh]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      # アクセストークンは有効期限を短く設定（例：15分）
      access_token = JsonWebToken.encode({ user_id: user.id, exp: 15.minutes.from_now.to_i })
      refresh_token = SecureRandom.urlsafe_base64

      user.update(refresh_token: refresh_token)

      render(
        json: {
          access_token: access_token,
          refresh_token: refresh_token,
          user: {
            id: user.id,
            email: user.email,
          },
        },
        status: :ok,
      )
    else
      render(json: { error: "メールアドレスまたはパスワードが正しくありません" }, status: :unauthorized)
    end
  end

  # リフレッシュトークンを使って新しいアクセストークンを発行する
  def refresh
    user = User.find_by(refresh_token: params[:refresh_token])

    if user
      access_token = JsonWebToken.encode({ user_id: user.id, exp: 15.minutes.from_now.to_i })
      new_refresh_token = SecureRandom.urlsafe_base64

      user.update(refresh_token: new_refresh_token)

      render(json: { access_token: access_token, refresh_token: new_refresh_token }, status: :ok)
    else
      render(json: { error: "無効なリフレッシュトークンです" }, status: :unauthorized)
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
    render(json: { message: "ログアウトしました" }, status: :ok)
  end
end
