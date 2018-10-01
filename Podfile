source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_modular_headers!

workspace 'Nazabore.xcworkspace'

def import_common
	pod 'libextobjc'
	pod 'UIDevice-Hardware'
end

target 'Nazabore' do
	project 'Nazabore.xcodeproj'
	import_common
	pod 'XCGLogger', '6.1.0'
	pod 'Fabric'
	pod 'Crashlytics'
	pod 'SSKeychain'
	pod 'Masonry'
	pod 'YMSwipeTableViewCell'
	pod 'SwiftProtobuf'
	pod 'Alamofire', '4.7.3'
	pod 'AlamofireNetworkActivityIndicator', '2.3.0'
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'

end

target 'UIWrapper' do
	project 'Nazabore.xcodeproj'
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
end

target 'NZBLibraryDemo' do
	project 'NZBLibrary/NZBLibraryDemo/NZBLibraryDemo.xcodeproj'
	import_common
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
end

target 'NZBLibraryDemoTests' do
	project 'NZBLibrary/NZBLibraryDemo/NZBLibraryDemo.xcodeproj'
	import_common
	pod 'Kiwi'
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
end

target 'NazaboreTests' do
	project 'Nazabore.xcodeproj'
	import_common
	pod 'Kiwi'
end
