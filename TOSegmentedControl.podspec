Pod::Spec.new do |s|
  s.name     = 'TOSegmentedControl'
  s.version  = '1.0.0'
  s.license  =  { :type => 'MIT', :file => 'LICENSE' }
  s.summary  = 'A segmented control in the style of iOS 13 compatible with previous versions of iOS.'
  s.homepage = 'https://github.com/TimOliver/TOSegmentedControl'
  s.author   = 'Tim Oliver'
  s.source   = { :git => 'https://github.com/TimOliver/TOSegmentedControl.git', :tag => s.version }
  s.platform = :ios, '10.0'
  s.source_files = 'TOSegmentedControl/**/*.{h,m}'
  s.requires_arc = true
end
