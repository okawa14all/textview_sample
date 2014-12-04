# -*- coding: utf-8 -*-
$:.unshift('/Library/RubyMotion/lib')
require 'motion/project/template/ios'
require 'bundler'
Bundler.require

require 'bubble-wrap/core'
require 'motion-support/core_ext/object'

Motion::Project::App.setup do |app|

  app.name = 'textview_sample'
  app.identifier = 'com.your_domain_here.textview_sample'
  app.short_version = '0.1.0'
  app.version = app.short_version

  # SDK 8 for iOS 8 and above
  # app.sdk_version = '8.1'
  # app.deployment_target = '8.0'

  # SDK 8 for iOS 7 and above
  app.sdk_version = '8.1'
  app.deployment_target = '7.1'

  # Or for SDK 7
  # app.sdk_version = '7.1'
  # app.deployment_target = '7.0'

  app.icons = ["icon@2x.png", "icon-29@2x.png", "icon-40@2x.png", "icon-60@2x.png", "icon-76@2x.png", "icon-512@2x.png"]

  # prerendered_icon is only needed in iOS 6
  #app.prerendered_icon = true

  app.device_family = [:iphone]
  app.interface_orientations = [:portrait]

  app.files += Dir.glob(File.join(app.project_dir, 'lib/**/*.rb'))

  app.frameworks += [
    'Accounts',
    'AudioToolbox',
    'CFNetwork',
    'CoreGraphics',
    'CoreLocation',
    'MobileCoreServices',
    'QuartzCore',
    'Security',
    'Social',
    'StoreKit',
    'SystemConfiguration']

  app.libs += [
    '/usr/lib/libz.dylib',
    '/usr/lib/libsqlite3.dylib']

  app.pods do
    pod 'MJAutoComplete'
    pod 'SZTextView'
    pod 'FontAwesomeKit/IonIcons'
  end

end
