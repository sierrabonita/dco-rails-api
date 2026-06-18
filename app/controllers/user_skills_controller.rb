# frozen_string_literal: true

class UserSkillsController < ApplicationController
  before_action :set_user
  before_action :set_user_skill, only: [:show, :update, :destroy]
  before_action :authorize_user!, only: [:create, :update, :destroy]

  def index
    user_skills = @user.user_skills.includes(:skill)
    render(json: UserSkillResource.new(user_skills).serialize)
  end

  def show
    render(json: UserSkillResource.new(@user_skill).serialize)
  end

  def create
    # スキル名で既存のマスターデータを検索、なければ新規作成
    @skill = Skill.find_or_initialize_by(name: user_skill_params[:name])
    @skill.layer = user_skill_params[:layer] if @skill.new_record?

    @skill.save!

    # 中間テーブルのレコードを作成・更新
    @user_skill = @user.user_skills.find_or_initialize_by(skill: @skill)
    @user_skill.rating = user_skill_params[:rating]
    @user_skill.description = user_skill_params[:description]

    @user_skill.save!
    render(json: UserSkillResource.new(@user_skill).serialize, status: :created)
  end

  def update
    @user_skill.update!(rating: user_skill_params[:rating], description: user_skill_params[:description])
    render(json: UserSkillResource.new(@user_skill).serialize)
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
    # ネストしたリソースを扱うため、skill_idではなくuser_skillsテーブルのidで検索する
    @user_skill = @user.user_skills.find(params[:id])
  end

  # フロントエンドの既存のペイロード構造を壊さないように require(:skill) のままにしています
  def user_skill_params
    params.require(:skill).permit(:name, :layer, :rating, :description)
  end

  def authorize_user!
    render(json: { error: "権限がありません" }, status: :forbidden) unless @current_user == @user
  end
end
