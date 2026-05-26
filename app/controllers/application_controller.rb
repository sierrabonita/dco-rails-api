class ApplicationController < ActionController::API
  before_action :authenticate_request
  attr_reader :current_user

  rescue_from StandardError, with: :render_500

  private

    def authenticate_request
      header = request.headers["Authorization"]
      token = header.split(" ").last if header

      decoded = JsonWebToken.decode(token) if token
      @current_user = User.find_by(id: decoded[:user_id]) if decoded

      unless @current_user
        render json: { error: "Not Authorized" }, status: :unauthorized
      end
    end

    def render_500(exception)
      logger.error(exception)
      logger.error(exception.backtrace.join("\n"))

      render json: {
               error: "サーバー内部で予期せぬエラーが発生しました"
             },
             status: :internal_server_error
    end
end
