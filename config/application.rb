require_relative 'boot'

require "rails"
# Pick the frameworks you want:
# require "active_model/railtie"
# require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

APP_SLUG = 'trade-tariff'

module TradeTariffFrontend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.autoloader = :classic

    require 'trade_tariff_frontend'

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    config.eager_load_paths += %W( #{config.root}/app/models/concerns
                                   #{config.root}/app/presenters
                                   #{config.root}/app/serializers
                                   #{config.root}/app/forms )

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql

    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = false #will move to mongo for API

    # Generator config
    config.generators do |g|
      g.orm             false
      g.template_engine :erb
      g.test_framework  false
    end

    config.middleware.insert_before 0, TradeTariffFrontend::BasicAuth do |name, password|
      ActiveSupport::SecurityUtils.secure_compare(name, TradeTariffFrontend::Locking.user) &
        ActiveSupport::SecurityUtils.secure_compare(password, TradeTariffFrontend::Locking.password)
    end

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV['CORS_HOST'] || '*'
        resource '*',
                 headers: :any,
                 methods: %i[get options]
      end
    end

    # Disable Rack::Cache.
    config.action_dispatch.rack_cache = nil

    # Tells Rails to serve error pages from the app itself, rather than using static error pages in public/
    config.exceptions_app = self.routes

    # Trade Tariff Backend API Version
    config.x.backend.api_version = ENV["TARIFF_API_VERSION"] || 1

    config.x.http.max_retry = 5

    config.middleware.use Rack::Attack
  end
end
