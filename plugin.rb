# frozen_string_literal: true

# name: DiscourseJwtSession
# about: Store the user's session details in a JWT cookie, in addition to the primary session cookie, so it can be accessed from other sites on your domain
# version: 0.1
# authors: wilson29thid
# url: https://github.com/29th/discourse-jwt-session

enabled_site_setting :jwt_session_enabled

PLUGIN_NAME ||= 'DiscourseJwtSession'

after_initialize do
  class JwtCurrentUserProvider < Auth::DefaultCurrentUserProvider
    def log_on_user(user, session, cookies, opts = {})
      super

      cookie_name = SiteSetting.jwt_session_cookie_name
      secret_key = GlobalSetting.safe_secret_key_base
      algorithm = 'HS256'

      payload = {
        sub: user.id,
        name: user.email
      }

      jwt = JWT.encode(payload, secret_key, algorithm)
      jwt_cookie = cookie_hash(jwt)
      jwt_cookie[:domain] = :all
      cookies[cookie_name] = jwt_cookie
    end

    def log_off_user(session, cookies)
      super

      cookie_name = SiteSetting.jwt_session_cookie_name
      cookies.delete(cookie_name, domain: :all)
    end
    
    def cookie_hash(unhashed_auth_token)
      hash = {
        value: unhashed_auth_token,
        httponly: true,
        secure: SiteSetting.force_https
      }
  
      if SiteSetting.persistent_sessions
        hash[:expires] = SiteSetting.maximum_session_age.hours.from_now
      end
  
      if SiteSetting.same_site_cookies != "Disabled"
        hash[:same_site] = SiteSetting.same_site_cookies
      end
  
      hash
    end
  end


  Discourse.current_user_provider = JwtCurrentUserProvider
end
