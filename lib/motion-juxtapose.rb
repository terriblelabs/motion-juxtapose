require "juxtapose/version"
require "juxtapose/image_matcher"
require "juxtapose/screenshotter"
require "juxtapose/strategy/frank_strategy"
require "juxtapose/strategy/capybara_strategy"
require "juxtapose/strategy/appium_strategy"

if defined?(Motion::Project::Config)
  Motion::Project::App.setup do |app|
    ENV["RUBYMOTION_PROJECT_DIR"] = Dir.pwd

    Dir.glob(File.join(File.dirname(__FILE__), 'juxtapose/**/*.rb')).reverse.each do |file|
      unless file.match(/juxtapose\/application/)
        app.files.unshift(file)
      end
    end
  end
end
