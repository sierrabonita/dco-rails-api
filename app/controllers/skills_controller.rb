# frozen_string_literal: true

class SkillsController < ApplicationController
  before_action :set_skill, only: %i[show update destroy]
  before_action :require_admin, only: %i[create update destroy]

  # GET /skills
  def index
    @pagy, @skills = pagy(Skill.all)

    render(json: {
             data: SkillResource.new(@skills).serializable_hash,
             meta: @pagy.data_hash
           })
  end

  # GET /skills/1
  def show
    render(json: SkillResource.new(@skill).serialize)
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)

    @skill.save!
    render(json: SkillResource.new(@skill).serialize, status: :created, location: @skill)
  end

  # PATCH/PUT /skills/1
  def update
    @skill.update!(skill_params)
    render(json: SkillResource.new(@skill).serialize)
  end

  # DELETE /skills/1
  def destroy
    @skill.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_skill
    @skill = Skill.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def skill_params
    params.require(:skill).permit(:name, :layer, :rating, :description)
  end
end
