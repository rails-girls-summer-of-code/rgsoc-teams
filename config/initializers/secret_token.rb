# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

RgsocTeams::Application.config.secret_key_base = ENV['RAILS_SESSION_SECRET'] || '73d112362109022a68873f5942358fd50138e1edff8fafdd7ad668c93116f535ff035e58c959876c2b3c1b44c7a1ad708f5d7f2dfe936043920f5c2dd7535934'
