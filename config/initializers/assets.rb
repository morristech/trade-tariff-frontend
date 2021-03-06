# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = ENV["ASSETS_VERSION"] || '1.0'

# Enable the asset pipeline
Rails.application.config.assets.enabled = true

Rails.application.config.assets.prefix = "/assets#{ENV['ASSETS_VERSION']}"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
# Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.

Rails.application.config.assets.precompile += %w{
  favicon.ico
  ui-icons_222222_256x240.png
  application.css
  application.js
  application-ie8.css
  application-ie7.css
  application-ie6.css
  tariff.css
  tariff-print.css
  gov.uk_logotype_crown.svg
  apple-touch-icon.png
  apple-touch-icon-180x180.png
  apple-touch-icon-167x167.png
  apple-touch-icon-152x152.png
}
