Myflix::Application.configure do

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.serve_static_assets = false

  config.assets.compress = true
  config.assets.js_compressor = :uglifier

  config.assets.compile = false

  config.assets.digest = true

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify
  
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'node62.mtl.net.vexxhost.com',
    port:                 465,
    user_name:            Rails.application.secrets.smtp_username,
    password:             Rails.application.secrets.smtp_password,
    authentication:       'plain',
    enable_starttls_auto: true  }
end
