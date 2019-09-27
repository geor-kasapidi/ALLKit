Pod::Spec.new do |s|
  s.name                       = 'ALLKit'
  s.version                    = '1.0'
  s.summary                    = 'Async List Layout Kit'
  s.homepage                   = 'https://github.com/geor-kasapidi/ALLKit'
  s.license                    = { :type => 'MIT', :file => 'LICENSE' }
  s.author                     = { 'Georgy Kasapidi' => 'geor.kasapidi@icloud.com' }
  s.source                     = { :git => 'https://github.com/geor-kasapidi/ALLKit.git', :tag => "v#{s.version}" }
  s.platform                   = :ios, '9.0'
  s.requires_arc               = true
  s.default_subspecs           = 'ListKit', 'StringBuilder'

  s.subspec 'FlexBox' do |ss|
    ss.source_files             = 'Sources/FlexBox/*.swift'
    ss.frameworks               = 'Foundation', 'CoreGraphics'
    ss.library                  = 'c++'
    ss.dependency                 'Yoga', '1.14'
  end

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
    ss.dependency                 'ALLKit/FlexBox'
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
end
