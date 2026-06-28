# frozen_string_literal: true

# ユーザーとスキル情報の紐付け（UserSkill）の管理とCRUD処理を行うコントローラ
class UserSkillsController < ApplicationController
  before_action :set_user
  before_action :set_user_skill, only: %i[show update destroy]
  before_action :authorize_user!, only: %i[create update destroy]

  def index
    custom_limit = params[:limit] || 10
    @pagy, user_skills = pagy(@user.user_skills.includes(:skill), limit: custom_limit)
    render(json: {
             data: UserSkillResource.new(user_skills).serializable_hash,
             meta: @pagy.data_hash
           })
  end

  def show
    render(json: UserSkillResource.new(@user_skill).serialize)
  end

  def create
    ActiveRecord::Base.transaction do
      @skill = find_or_create_skill!
      @user_skill = create_or_update_user_skill!(@skill)
    end

    render json: UserSkillResource.new(@user_skill).serialize, status: :created
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
    render(json: { error: '権限がありません' }, status: :forbidden) unless @current_user == @user
  end

  def find_or_create_skill!
    Skill.find_or_initialize_by(name: user_skill_params[:name]).tap do |skill|
      skill.layer = user_skill_params[:layer] if skill.new_record?
      skill.save!
    end
  end

  def create_or_update_user_skill!(skill)
    @user.user_skills.find_or_initialize_by(skill: skill).tap do |user_skill|
      user_skill.rating = user_skill_params[:rating]
      user_skill.description = user_skill_params[:description]
      user_skill.save!
    end
  end
end
