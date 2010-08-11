# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_dayjob_session',
  :secret      => '7230bc2b6823a35a3d8fadb3b13e1dde9c4f8f2b91db0fe877fedb93b0676184d6dd351697b5b001b1ae3a5378a9080e2960d9783a91ce58b41429c1fb57f639'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
