# frozen_string_literal: true

# name: DiscourseJwtSession
# about: Store the user's session details in a JWT cookie, in addition to the primary session cookie, so it can be accessed from other sites on your domain
# version: 0.1
# authors: wilson29thid
# url: https://github.com/29th/discourse-jwt-session

gem 'jwt'

enabled_site_setting :jwt_session_enabled

PLUGIN_NAME ||= 'DiscourseJwtSession'

load File.expand_path('lib/jwt_current_user_provider.rb', __dir__)

Discourse.current_user_provider = JwtCurrentUserProvider
