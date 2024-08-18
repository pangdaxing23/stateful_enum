# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in stateful_enum.gemspec
gemspec

if ENV['RAILS_VERSION'] == 'edge'
  gem 'rails', git: 'https://github.com/rails/rails.git'
elsif ENV['RAILS_VERSION']
  gem 'rails', "~> #{ENV['RAILS_VERSION']}.0"
  if ENV['RAILS_VERSION'] <= '5.0'
    gem 'sqlite3', '< 1.4'
  elsif ENV['RAILS_VERSION'] <= '7.1'
    gem 'sqlite3', '~> 1.4'
  end
else
  gem 'rails'
end

gem 'selenium-webdriver'
gem 'nokogiri', RUBY_VERSION < '2.1' ? '~> 1.6.0' : '>= 1.7'
gem 'loofah', RUBY_VERSION < '2.5' ? '< 2.21.0' : '>= 0'

if RUBY_VERSION >= '3.3'
  gem 'bigdecimal'
  gem 'mutex_m'
end
