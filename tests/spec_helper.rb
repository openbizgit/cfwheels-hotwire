require 'selenium-webdriver'
require 'capybara/mechanize'
require 'capybara/rspec'
require 'capybara-webkit'
require 'pry'
# TODO: mysql model testing with activerecord
#gem 'activerecord'
#gem 'mysql2', '> 0.3'

# include Capybara::DSL
RSpec.configure do |config|
  config.include Capybara::DSL
end

# configure Capybara
Capybara.configure do |config|
  config.run_server = false
  # for headless testing, use 'config.default_driver = :webkit'
  config.default_driver = :selenium
  #config.javascript_driver = :webkit
  config.app_host = 'http://hotwire/'
end

# configure activerecord mysql connection
# ActiveRecord::Base.establish_connection({
#   :adapter  => :mysql2,
#   :host => "localhost",
#   :username => "root",
#   :password => 'password',
#   :database => "hotwire"
# })
