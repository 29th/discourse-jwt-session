# frozen_string_literal: true

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
end
