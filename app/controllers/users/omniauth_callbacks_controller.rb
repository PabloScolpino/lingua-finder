# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    # rubocop:disable Metrics/AbcSize
    def google_oauth2
      if user.persisted?
        flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
        sign_in_and_redirect user, event: :authentication
      else
        # Removing extra as it can overflow some session stores
        session['devise.google_data'] = request.env['omniauth.auth'].except(:extra)
        redirect_to new_user_registration_url, alert: user.errors.full_messages.join("\n")
      end
    end
    # rubocop:enable Metrics/AbcSize

    # TODO: handle the oauth error routing in config/route
    def new_session_path(_scope)
      '/'
    end

    private

    def user
      @user ||= User.from_omniauth(request.env['omniauth.auth'])
    end
  end
end
