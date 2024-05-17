source "https://rubygems.org"

gem "dm_unibo_user_search", git: "https://github.com/donapieppo/dm_unibo_user_search.git"
gem "dm_unibo_common", git: "https://github.com/donapieppo/dm_unibo_common.git", branch: "master"

gem "jsbundling-rails"
gem "cssbundling-rails"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

gem "omniauth"
gem "omniauth-rails_csrf_protection"
gem "net-ldap"
gem "net-ldap-auth_adapter-gssapi"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri windows]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
end
