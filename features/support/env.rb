# Informs which gems should be utilized
require 'capybara'
require 'capybara/cucumber'
require 'rest-client'
require 'json'
require 'rspec'
require 'pry'
require 'pry-nav'
require 'selenium/webdriver'
require 'capybara/dsl'
require 'haml'

# Require all .rb files in features/support/helpers
Dir[__dir__ + '/helpers/*.rb'].each {|filename| require_relative filename} # require doesn't appear to work with our helper files so require_relative is used
World(Jira)

# Constant vars for downloads
DOWNLOAD_TIMEOUT = 10
DOWNLOAD_PATH = "downloads"

Capybara.default_driver = :selenium # sets selenium as the web driver

class CapybaraDriverRegistrar
  # Configures local driver
  def self.register_selenium_local_driver(browser, profile)
    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, browser: browser, profile: profile)
    end
  end

end

# The BUILD var is set in jenkins config. It will be found only if tests run in jenkins
# Cucumber defaults to local config settings otherwise

profile = Selenium::WebDriver::Chrome::Profile.new
profile["download.default_directory"] = DOWNLOAD_PATH
CapybaraDriverRegistrar.register_selenium_local_driver(:chrome, profile)

Capybara.default_max_wait_time = 10
window = Capybara.current_session.driver.browser.manage.window
window.resize_to(1366, 1000)
