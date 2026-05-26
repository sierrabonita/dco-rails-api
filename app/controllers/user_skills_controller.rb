# frozen_string_literal: true

class UserSkillsController < ApplicationController
  before_action :set_user
  before_action :set_user_skill, only: [:show, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    user_skills = @user.user_skills.includes(:skill)
    render(json: user_skills.map { |us| format_user_skill(us) })
  end

  def show
    render(json: format_user_skill(@user_skill))
  end

  def create
    # スキル名で既存のマスターデータを検索、なければ新規作成
    @skill = Skill.find_or_initialize_by(name: user_skill_params[:name])
    @skill.layer = user_skill_params[:layer] if @skill.new_record?

    if @skill.save
      # 中間テーブルのレコードを作成・更新
      @user_skill = @user.user_skills.find_or_initialize_by(skill: @skill)
      @user_skill.rating = user_skill_params[:rating]
      @user_skill.description = user_skill_params[:description]

      if @user_skill.save
        render(json: format_user_skill(@user_skill), status: :created)
      else
        render(json: @user_skill.errors, status: :unprocessable_content)
      end
    else
      render(json: @skill.errors, status: :unprocessable_content)
    end
  end

  def update
    if @user_skill.update(
      rating: user_skill_params[:rating],
      description: user_skill_params[:description],
    )
      render(json: format_user_skill(@user_skill))
    else
      render(json: @user_skill.errors, status: :unprocessable_content)
    end
  end

  # DELETE /users/:user_id/skills/:id
  def destroy
    @user_skill.destroy!
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_user_skill
    @user_skill = @user.user_skills.find_by!(skill_id: params[:id])
  end

  # フロントエンドの既存のペイロード構造を壊さないように require(:skill) のままにしています
  def user_skill_params
    params.require(:skill).permit(:name, :layer, :rating, :description)
  end

  def format_user_skill(user_skill)
    {
      id: user_skill.skill_id,
      name: user_skill.skill.name,
      layer: user_skill.skill.layer,
      rating: user_skill.rating,
      description: user_skill.description,
      created_at: user_skill.created_at,
      updated_at: user_skill.updated_at,
    }
  end

  def record_not_found
    render(json: { error: "指定されたデータが見つかりません" }, status: :not_found)
  end
end
