require 'action_dispatch/middleware/session/dalli_store'

Rails.application.config.session_store :dalli_store,
  :memcache_server => ['127.0.0.1'],
  :namespace => 'sessions',
  :key => '_h3d_session',
  :domain => :all,
  :expire_after => 120.years,
  :expire_in => 120.years
