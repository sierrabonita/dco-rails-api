# frozen_string_literal: true

# API全体で共通の認証、エラーハンドリングを提供するベースコントローラ
class ApplicationController < ActionController::API
  include Pagy::Method

  before_action :authenticate_request
  attr_reader :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request
  rescue_from Pagy::OptionError, with: :render_not_found
  rescue_from StandardError, with: :render_internal_server_error

  private

  def authenticate_request
    token = extract_token_from_header
    @current_user = find_user_by_token(token) if token

    render(json: { error: 'Not Authorized' }, status: :unauthorized) unless @current_user
  rescue JWT::ExpiredSignature
    render(json: { error: 'Token has expired' }, status: :unauthorized)
  rescue JWT::DecodeError
    render(json: { error: 'Invalid token' }, status: :unauthorized)
  end

  def extract_token_from_header
    header = request.headers['Authorization']
    header&.split&.last
  end

  def find_user_by_token(token)
    decoded = JsonWebToken.decode(token)
    User.find_by(id: decoded[:user_id])
  end

  def require_admin
    return if @current_user&.admin?

    render(json: { error: '管理者権限がありません' }, status: :forbidden)
  end

  def render_bad_request(exception)
    render(json: { error: "必須パラメータが不足しています: #{exception.param}" }, status: :bad_request)
  end

  def render_not_found
    render(json: { error: '指定されたデータが見つかりません' }, status: :not_found)
  end

  def render_unprocessable_entity(exception)
    render(json: { errors: exception.record.errors.full_messages }, status: :unprocessable_content)
  end

  def render_internal_server_error(exception)
    logger.error(exception)
    logger.error(exception.backtrace.join("\n"))

    render(
      json: {
        error: 'サーバー内部で予期せぬエラーが発生しました'
      },
      status: :internal_server_error
    )
  end
end
