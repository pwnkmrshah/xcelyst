Rails.application.configure do
  config.hosts = nil 
  # Settings specified here will take precedence over those in config/application.rb.
  # for image URLs in HTML email
  Rails.application.routes.default_url_options[:host] = ENV['REMOTE_URL'] || "http://localhost:3000"

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false
  config.log_level = ENV['RAILS_LOGLEVEL'].present? ? ENV['RAILS_LOGLEVEL'].to_sym : :info
  # Do not eager load code on boot.
  config.eager_load = true

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.smtp_settings = {
    address:              ENV["SMTP_ADD"],
    port:                 587,
    domain:               ENV["SMTP_DOMAIN"],
    user_name:            ENV["SMTP_USER"],
    password:             ENV["SMTP_PASS"],
    authentication:       :login,
    enable_starttls_auto: true,
    openssl_verify_mode: "none"
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  
  config.active_job.queue_adapter = :sidekiq

  config.assets.precompile += %w[active_admin.scss active_admin.js custom.js custom.scss xcelyst_logo.png]

  # Store uploaded files on the local file system (see config/storage.yml for options).
  # config.active_storage.service = :local
  config.active_storage.service = :amazon
  config.assets.compress = true
  config.assets.debug = true
  config.assets.compile = true

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true


  # Raises error for missing translations.
  config.action_view.raise_on_missing_translations = true
  config.action_cable.mount_path = '/cable'
  config.action_cable.url = 'wss://localhost:3000/cable'
  config.action_cable.allowed_request_origins = [/http:\/\/*/, /https:\/\/*/, nil]
  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
