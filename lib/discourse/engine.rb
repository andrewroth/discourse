module Discourse
  class Engine < Rails::Engine
    #isolate_namespace Discourse

    config.to_prepare do
      Dir.glob(File.join(Rails.root + 'app/**/*_conern.rb')).each do |c|
        require_dependency(c)
      end

      Dir.glob(File.join(Rails.root + 'app/decorators/**/*_decorator.rb')).each do |c|
        require_dependency(c)
      end
    end

    # copied from config/application.rb

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    require 'discourse'
    require 'discourse/es6_module_transpiler/rails'
    require 'discourse/js_locale_helper'

    # mocha hates us, active_support/testing/mochaing.rb line 2 is requiring the wrong
    #  require, patched in source, on upgrade remove this
=begin
    if Rails.env.test? || Rails.env.development?
      require "mocha/version"
      require "mocha/deprecation"
      if Mocha::VERSION == "0.13.3" && Rails::VERSION::STRING == "3.2.12"
        Mocha::Deprecation.mode = :disabled
      end
    end
=end

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoload_paths << "#{config.root}/app/serializers"
    config.autoload_paths << "#{config.root}/lib/"
    config.autoload_paths << "#{config.root}/lib/validators/"
    config.autoload_paths << "#{config.root}/app"

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    initializer "discourse.asset_precompile_paths" do |app|
      app.config.assets.paths += %W(#{config.root}/config/locales #{config.root}/public/javascripts)

      # explicitly precompile any images in plugins ( /assets/images ) path
      app.config.assets.precompile += [lambda do |filename, path|
        path =~ /assets\/images/ && !%w(.js .css).include?(File.extname(filename))
      end]
      app.config.assets.precompile += ['vendor.js', 'common.css', 'desktop.css', 'mobile.css', 'admin.js', 'admin.css', 'shiny/shiny.css', 'preload_store.js', 'browser-update.js', 'embed.css', 'break_string.js']

      # Precompile all defer
      Dir.glob("#{config.root}/app/assets/javascripts/defer/*.js").each do |file|
        app.config.assets.precompile << "defer/#{File.basename(file)}"
      end

      # Precompile all available locales
      Dir.glob("#{config.root}/app/assets/javascripts/locales/*.js.erb").each do |file|
        app.config.assets.precompile << "locales/#{file.match(/([a-z_A-Z]+\.js)\.erb$/)[1]}"
      end
    end

    # Activate observers that should always be running.
    config.active_record.observers ||= []
    config.active_record.observers += [
      'user_email_observer',
      'user_action_observer',
      'post_alert_observer',
      'search_observer'
    ]

    # Enable the asset pipeline
    #config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    #config.assets.version = '1.2.4'

    # We need to be able to spin threads
    config.active_record.thread_safe!

    # see: http://stackoverflow.com/questions/11894180/how-does-one-correctly-add-custom-sql-dml-in-migrations/11894420#11894420
    #config.active_record.schema_format = :sql

    # per https://www.owasp.org/index.php/Password_Storage_Cheat_Sheet
    config.pbkdf2_iterations = 64000
    config.pbkdf2_algorithm = "sha256"

    # rack lock is nothing but trouble, get rid of it
    # for some reason still seeing it in Rails 4
    config.middleware.delete Rack::Lock

    # ETags are pointless, we are dynamically compressing
    # so nginx strips etags, may revisit when mainline nginx
    # supports etags (post 1.7)
    config.middleware.delete Rack::ETag

    # route all exceptions via our router
    config.exceptions_app = self.routes

    # Our templates shouldn't start with 'discourse/templates'
    # TODO move to main app?
    #config.handlebars.templates_root = 'discourse/templates'

    #initializer "discourse.load_app_root" do |app|
    config.before_initialize do |app|
      require 'discourse_redis'
      require 'logster/redis_store'
      # Use redis for our cache
      #app.config.cache_store = DiscourseRedis.new_redis_store
      $redis = DiscourseRedis.new
      Logster.store = Logster::RedisStore.new(DiscourseRedis.new)
    end

    # we configure rack cache on demand in an initializer
    # our setup does not use rack cache and instead defers to nginx
    config.action_dispatch.rack_cache =  nil

    config.after_initialize do |app|
      # ember stuff only used for asset precompliation, production variant plays up
      app.config.ember.variant = :development
      app.config.ember.ember_location = "#{Rails.root}/vendor/assets/javascripts/production/ember.js"
      app.config.ember.handlebars_location = "#{Rails.root}/vendor/assets/javascripts/handlebars.js"

      require 'auth'
      Discourse.activate_plugins! unless Rails.env.test? and ENV['LOAD_PLUGINS'] != "1"

      config.after_initialize do
        # So open id logs somewhere sane
        OpenID::Util.logger = Rails.logger
        if plugins = Discourse.plugins
          plugins.each{|plugin| plugin.notify_after_initialize}
        end
      end
    end
  end
end
