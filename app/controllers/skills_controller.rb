# frozen_string_literal: true

class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :update, :destroy]

  # GET /skills
  def index
    @skills = Skill.all

    render(json: @skills)
  end

  # GET /skills/1
  def show
    render(json: @skill)
  end

  # POST /skills
  def create
    @skill = Skill.new(skill_params)

    @skill.save!
    render(json: @skill, status: :created, location: @skill)
  end

  # PATCH/PUT /skills/1
  def update
    @skill.update!(skill_params)
    render(json: @skill)
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
