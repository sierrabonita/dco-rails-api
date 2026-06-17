# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all

    render(json: @users, only: [:id, :name, :email, :created_at])
  end

  def show
    render(json: @user, only: [:id, :name, :email, :created_at])
  end

  def create
    @user = User.new(user_params)

    @user.save!
    render(json: @user, only: [:id, :name, :email], status: :created)
  end

  def update
    @user.update!(user_params)
    render(json: @user, only: [:id, :name, :email])
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
