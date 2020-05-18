class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable

  # ユーザーをuidで検索する。無ければproviderから情報を取得し作成する。
  def self.find_for_oauth(auth)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
        uid:  auth.uid,
        provider: auth.provider,
        email:  User.duummy_email(auth),
        password: Devise.friendly_token[0, 20],
        image:  auth.info.image.gsub("_normal", ""),
        name: auth.info.name,
        nickname: auth.info.nickname,
        description: auth.info.description
      )
    end
    user
  end

  def self.duummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
  end

  def self.update_for_oauth(user, auth)
    user.update(
      name: auth.info.name,
      uid: auth.uid,
      provider: auth.provider,
      image: auth.info.image.gsub("_normal", ""),
      nickname: auth.info.nickname,
    )
  end

  # 現在のpassword無しでemailとpasswordを変更できるようにする
  def update_without_current_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update_attributes(params, *options)
    clean_up_passwords
    result
  end

end


