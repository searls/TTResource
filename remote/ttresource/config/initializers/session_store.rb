# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ttresource_session',
  :secret      => 'e0aa0045efe3c0ea49ec01d553f26edaf49284cc000ba9d45d280f7834178b2255f2b6e3830ad6e4c4fc194d21c417101f393dfaaa4de534a56394597f5bf6d3'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
