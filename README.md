# Discourse JWT Session

Store the user's session details in a JWT cookie, in addition to the primary
session cookie, so it can be accessed from other sites on your domain

## Installation

Follow [Install a Plugin](https://meta.discourse.org/t/install-a-plugin/19157)
how-to from the official Discourse Meta, using `git clone https://github.com/29th/discourse-jwt-session.git`
as the plugin command.

## Verification

Get the Secret key base from Discourse:

```
./launcher enter app
rails console
GlobalSetting.safe_secret_key_base
```

Pass that to your other application securely, e.g. via an environment variable.

On your other application, verify the signature of the JWT, e.g.

```ruby
require 'jwt'

def decode(token)
  secret_key = ENV['DISCOURSE_SECRET_KEY_BASE']
  verify = true
  options = { algorithm: 'HS256' }
  body, header = JWT.decode(token, secret_key, verify, options)
  HashWithIndifferentAccess.new body
end

jwt = cookies[:discourse_jwt]
decoded = decode(jwt)
discourse_user_id = decoded[:sub]
User.find_by_discourse_id(discourse_user_id)
```

## Credits

Heavy inspiration from [mpgn/discourse-cookie-token-domain](https://github.com/mpgn/discourse-cookie-token-domain)
