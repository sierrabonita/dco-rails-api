# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Pagy::Method

  before_action :authenticate_request
  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from ActiveRecord::RecordInvalid, with: :render_422
  rescue_from ActionController::ParameterMissing, with: :render_400
  rescue_from Pagy::OptionError, with: :render_404
  rescue_from StandardError, with: :render_500

  private

  def authenticate_request
    # AuthorizationヘッダーからBearerトークンを取得
    header = request.headers["Authorization"]

    # Bearerトークンは "Bearer <token>" の形式で送られるため、スペースで分割してトークン部分を取得
    token = header.split(" ").last if header

    if token
      begin
        decoded = JsonWebToken.decode(token)
        @current_user = User.find_by(id: decoded[:user_id])
      rescue JWT::ExpiredSignature
        return render(json: { error: "Token has expired" }, status: :unauthorized)
      rescue JWT::DecodeError
        return render(json: { error: "Invalid token" }, status: :unauthorized)
      end
    end

    unless @current_user
      render(json: { error: "Not Authorized" }, status: :unauthorized)
    end
  end

  def render_400(exception)
    render(json: { error: "必須パラメータが不足しています: #{exception.param}" }, status: :bad_request)
  end

  def render_404
    render(json: { error: "指定されたデータが見つかりません" }, status: :not_found)
  end

  def render_422(exception)
    render(json: { errors: exception.record.errors.full_messages }, status: :unprocessable_content)
  end

  def render_500(exception)
    logger.error(exception)
    logger.error(exception.backtrace.join("\n"))

    render(
      json: {
        error: "サーバー内部で予期せぬエラーが発生しました",
      },
      status: :internal_server_error,
    )
  end
end
