@version = "1.0.18"

Pod::Spec.new do |s|
  s.name         	= 'VXWalkthroughViewController'
  s.version      	= @version
  s.summary     	= 'A simple display of walkthroughs in apps.'
  s.homepage 	   	= 'https://github.com/swiftmanagementag/VXWalkthroughViewController'
  s.license			= { :type => 'MIT', :file => 'LICENSE' }
  s.author       	= { 'Graham Lancashire' => 'lancashire@swift.ch' }
  s.source       	= { :git => 'https://github.com/swiftmanagementag/VXWalkthroughViewController.git', :tag => s.version.to_s }
  s.platform     	= :ios, '10.0'
  s.source_files 	= 'VXWalkthroughViewController/**/*.{h,m}'
  s.resources 		= 'VXWalkthroughViewController/**/*.{bundle,xib,png,lproj,storyboard}'
  s.resource_bundles = {
    'VXWalkthroughViewController' => ['VXWalkthroughViewController/**/*.{bundle,xib,png,lproj,storyboard}']
  }
  s.requires_arc 	= true
  s.framework		= 'QuartzCore'
  s.dependency    'Slash', '~> 0.1'
  s.dependency    'QRCodeReaderViewController', '~> 4.0.2'
end
