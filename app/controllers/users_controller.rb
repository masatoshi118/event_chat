class UsersController < ApplicationController

  before_action :user_signin_check

  def show
    @user = User.find(params[:id])
    @joined_events = @user.joined_events.order(updated_at: "DESC").page(params[:page]).per(5)
    @holded_events = @user.events.order(updated_at: "DESC").page(params[:page]).per(5)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    redirect_to user_path
  end

  def user_update
    user = User.find(params[:id])
    search_id = user[:uid].to_i
    if request.patch? && !search_id.zero?
      user.update(
        name: client.user(search_id).name,
        nickname: client.user(search_id).screen_name,
        # 式展開しないと文字列形式で取得できない
        remote_image_url: "#{client.user(search_id).profile_image_url_https}".gsub("_normal", ""),
        description: client.user(search_id).description
      )
    else
      flash[:alert] = 'Twitter連携後に使用することができます'
      redirect_to (edit_user_path(user)) and return
    end
    redirect_to user_path(user.id)
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

    def user_signin_check
      unless user_signed_in?
        redirect_to root_url
      end
    end
end