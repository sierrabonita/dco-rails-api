# frozen_string_literal: true

# ユーザー情報（名前、メールアドレスなど）の管理、検索、およびCRUD処理を行うコントローラ
class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :require_admin, only: %i[create destroy]
  before_action :set_user, only: %i[show update destroy]
  before_action :authorize_user!, only: %i[update destroy]

  def index
    users_query = filter_users(User.includes(user_skills: :skill))
    @pagy, @users = pagy(users_query)

    render(json: {
             data: UserResource.new(@users).serializable_hash,
             meta: @pagy.data_hash
           })
  end

  def show
    render(json: UserResource.new(@user).serialize)
  end

  def create
    @user = User.new(user_params)

    @user.save!
    render(json: UserResource.new(@user).serialize, status: :created)
  end

  def update
    @user.update!(user_params)
    render(json: UserResource.new(@user).serialize)
  end

  def destroy
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def authorize_user!
    render(json: { error: '権限がありません' }, status: :forbidden) unless @current_user == @user
  end

  def filter_users(query)
    filters = {
      skill_ids: :by_skills,
      min_rating: :min_rating,
      keyword: :search_by_name
    }

    filters.reduce(query) do |q, (param_key, scope_name)|
      params[param_key].present? ? q.public_send(scope_name, params[param_key]) : q
    end
  end
end
