Pod::Spec.new do |s|
  s.name                       = 'ALLKit'
  s.version                    = '1.2'
  s.summary                    = 'Async List Layout Kit'
  s.homepage                   = 'https://github.com/geor-kasapidi/ALLKit'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.author                     = { 'Georgy Kasapidi' => 'geor.kasapidi@icloud.com' }
  s.source                     = { :git => 'https://github.com/geor-kasapidi/ALLKit.git', :tag => "v#{s.version}" }
  s.platform                   = :ios, '9.0'
  s.swift_version              = '5.1'
  s.requires_arc               = true
  s.default_subspecs           = 'ListKit', 'StringBuilder'

  s.subspec 'Diff' do |ss|
    ss.source_files             = 'Sources/Diff/*.swift'
  end

  s.subspec 'StringBuilder' do |ss|
    ss.source_files             = 'Sources/StringBuilder/*.swift'
    ss.frameworks               = 'Foundation', 'UIKit'
  end

  s.subspec 'Layout' do |ss|
    ss.source_files             = 'Sources/Layout/*.swift'
    ss.frameworks               = 'Foundation', 'UIKit'
    ss.library                  = 'c++'
    ss.dependency                 'Yoga', '1.14'
  end

  s.subspec 'Support' do |ss|
    ss.source_files             = 'Sources/Support/*.swift'
    ss.frameworks               = 'Foundation', 'UIKit'
    ss.dependency                 'ALLKit/Layout'
  end

  s.subspec 'ListKit' do |ss|
    ss.source_files             = 'Sources/ListKit/*.swift'
    ss.frameworks               = 'Foundation', 'UIKit'
    ss.dependency                 'ALLKit/Layout'
    ss.dependency                 'ALLKit/Diff'
    ss.dependency                 'ALLKit/Support'
  end

  bundleId = 'com.nseven.allkit'

  s.app_spec 'Demos' do |as|
    as.ios.deployment_target = '10.0'
    as.source_files = 'Demos/**/*.swift'
    as.resources = 'Demos/Assets.xcassets'
    as.info_plist = {
      'CFBundleIdentifier' => bundleId,
      'UIUserInterfaceStyle' => 'Light'
    }
    as.pod_target_xcconfig = {
      'PRODUCT_BUNDLE_IDENTIFIER' => bundleId
    }
    as.dependency 'PinIt'
    as.dependency 'Nuke'
  end

  s.test_spec 'Tests' do |ts|
    ts.requires_app_host = true
    ts.test_type = :unit
    ts.source_files = 'Tests/**/*.swift'
    ts.app_host_name = 'ALLKit/Demos'
    ts.dependency 'ALLKit/Demos'
  end
end
