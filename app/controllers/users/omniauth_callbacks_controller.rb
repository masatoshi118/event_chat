class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    callback_from :twitter
  end

  private

  def callback_from(provider)
    provider = provider.to_s
    auth = request.env['omniauth.auth']

    if user_signed_in?
      @user = current_user
      user_check = User.where(uid: auth.uid, provider: auth.provider).first

      if user_check
        flash[:alert] = I18n.t('devise.omniauth_callbacks.failure', kind: provider.capitalize, reason: 'このアカウントは既に使用されています')
        redirect_to (root_path) and return 
      else
        User.update_for_oauth(@user, auth)
      end
    else
      @user = User.find_for_oauth(auth)
    end

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{provider}_data"] = auth
      redirect_to new_user_registration_url
    end
  end
end