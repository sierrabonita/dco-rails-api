# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:update, :destroy]

  def index
    @pagy, @users = pagy(User.includes(user_skills: :skill).all)

    render(json: {
      data: UserResource.new(@users).serializable_hash,
      meta: @pagy.data_hash,
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
    render(json: { error: "権限がありません" }, status: :forbidden) unless @current_user == @user
  end
end
