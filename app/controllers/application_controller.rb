class ApplicationController < ActionController::API
  rescue_from StandardError, with: :render_500

  private

  def render_500(exception)
    logger.error(exception)
    logger.error(exception.backtrace.join("\n"))

    render json: { error: "サーバー内部で予期せぬエラーが発生しました" }
  end
end
