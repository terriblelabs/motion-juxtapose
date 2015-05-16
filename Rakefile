# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project/template/ios'
require "bundler/gem_tasks"
Bundler.setup
Bundler.require

require 'motion-juxtapose'

Motion::Project::App.setup do |app|
  app.name = 'juxtapose-tests'
  app.detect_dependencies = false
  app.info_plist["UILaunchStoryboardName"] = "LaunchScreen"
end
