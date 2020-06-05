# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.7'

gem 'pg', '>= 0.18', '< 2.0'
gem 'rails', '5.2.4.3'

group :development, :test do
  gem 'rspec-rails'
end

group :test do
  gem 'database_cleaner-active_record'
  gem 'factory_bot_rails'
end
