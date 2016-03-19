source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
# use_frameworks!

workspace 'Nazabore.xcworkspace'

def import_common
	pod 'libextobjc'
end

target 'Nazabore' do
	import_common
	pod 'Crashlytics'
	pod 'Fabric'
	pod 'Masonry'
	pod 'YMSwipeTableViewCell'
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
	xcodeproj 'Nazabore.xcodeproj'
end

target 'UIWrapper' do
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
	xcodeproj 'Nazabore.xcodeproj'
end

target 'NZBLibraryDemo' do
	import_common
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
	xcodeproj 'NZBLibrary/NZBLibraryDemo/NZBLibraryDemo.xcodeproj'
end

target 'NZBLibraryDemoTests' do
	import_common
	pod 'Kiwi'
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
	xcodeproj 'NZBLibrary/NZBLibraryDemo/NZBLibraryDemo.xcodeproj'
end

target 'NazaboreTests' do
	import_common
	pod 'Kiwi'
	xcodeproj 'Nazabore.xcodeproj'
end

