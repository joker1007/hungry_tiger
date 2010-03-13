# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hungry_tiger_session',
  :secret      => '0bf58d9f4ae73f0b581fcb206bf41269c29efd5332d2ed8ecfc5d583980aa0e01a471094d6f0038969a3ddcc913189150b7704b700def08014cd6e9104012f14'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
