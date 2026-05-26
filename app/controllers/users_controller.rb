class UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]

  def index
    @users = User.all

    render json: @users, only: %i[id name email created_at]
  end

  def show
    render json: @user, only: %i[id name email created_at]
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, only: %i[id name email], status: :created
    else
      render json: @user.errors, status: :unprocessable_content
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, only: %i[id name email]
    else
      render json: @user.errors, status: :unprocessable_content
    end
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
end
