class PostsController < ApplicationController
  before_action :set_user
  before_action :set_user_post, only: %i[show update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    if @user
      @posts = @user.posts
    else
      @posts = Post.all
    end

    render json: @posts
  end

  def show
    render json: @post
  end

  def create
    if @user
      @post = @user.posts.build(post_params)
      if @post.save
        render json: @post, status: :created
      else
        render json: @post.errors, status: :unprocessable_content
      end
    else
      render json: { error: "ユーザーを指定してください" }, status: :bad_request
    end
  end

  def update
    if @post.update(post_params)
      render json: @post
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy!
  end

  private
    def set_user
      @user = User.find_by(id: params[:user_id])
    end

    def set_user_post
      if @user
        @post = @user.posts.find(params[:id])
      else
        @post = Post.find(params[:id])
      end
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end

    def record_not_found
      render json: { error: "指定されたデータが見つかりません" }, status: :not_found
    end
end
