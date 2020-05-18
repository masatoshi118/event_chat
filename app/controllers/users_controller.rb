class UsersController < ApplicationController

  before_action :user_signin_check

  def show
    @user = User.find(params[:id])
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
    if request.patch?
      image_url = "#{client.user(search_id).profile_image_url_https}"
      user.update(
        name: client.user(search_id).name,
        nickname: client.user(search_id).screen_name,
        # 式展開しないと文字列形式で取得できない
        image: image_url.gsub("_normal", ""),
        description: client.user(search_id).description
      )
    end
    redirect_to user_path(user.id)
  end

  private
    def user_params
        params.require(:user).permit(:name, :nickname, :email, :location)
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