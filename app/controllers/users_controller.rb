class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :user_exist?
  before_action :correct_user?, only: %i[ edit update user_update ]

  def show
    @user = User.find_by(id: params[:id])
    @joined_events = @user.joined_events.order(updated_at: "DESC").page(params[:page]).per(5)
    @holded_events = @user.events.order(updated_at: "DESC").page(params[:page]).per(5)
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:notice] = "プロフィールを編集しました。"
      redirect_to @user
    else
      render "edit"
    end
  end

  def user_update
    user = User.find_by(id: params[:id])
    search_id = user[:uid].to_i
    if request.patch? && !search_id.zero?
      flash[:notice] = "Twitterのプロフィールを反映しました。"
      user.update(
        name: client.user(search_id).name,
        nickname: client.user(search_id).screen_name,
        # 式展開しないと文字列形式で取得できない
        remote_image_url: "#{client.user(search_id).profile_image_url_https}".gsub("_normal", ""),
        description: client.user(search_id).description
      )
      redirect_to user_path(user.id)
    else
      flash[:alert] = 'Twitter連携後に使用することができます。'
      render "edit"
    end
  end

  private
    def user_params
        params.require(:user).permit(:name, :image, :description)
    end

    def client
      require 'twitter'
      return client = Twitter::REST::Client.new do |config|
        config.consumer_key = Rails.application.credentials.twitter[:TWITTER_API_KEY]
        config.consumer_secret = Rails.application.credentials.twitter[:TWITTER_API_SECRET_KEY]
        config.access_token = Rails.application.credentials.twitter[:TWITTER_ACCESS_TOKEN]
        config.access_token_secret = Rails.application.credentials.twitter[:TWITTER_ACCESS_TOKEN_SECRET]
      end
    end

    def user_exist?
      user = User.find_by(id: params[:id])
      if user.blank?
        flash[:alert] = '指定のユーザーは存在しません。'
        redirect_back(fallback_location: root_path)
      end
    end

    def correct_user?
      user = User.find_by(id: params[:id])
      if user != current_user
        flash[:alert] = '権限がありません。'
        redirect_back(fallback_location: root_path)
      end
    end

end