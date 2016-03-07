source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
# use_frameworks!

workspace 'Nazabore.xcworkspace'

target 'Nazabore' do
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
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
	xcodeproj 'NZBLibrary/NZBLibraryDemo/NZBLibraryDemo.xcodeproj'
end

target 'NZBLibraryDemoTests' do
	pod 'Kiwi'
	pod 'NZBLibrary', :path => 'NZBLibrary/NZBLibrary.podspec'
	xcodeproj 'NZBLibrary/NZBLibraryDemo/NZBLibraryDemo.xcodeproj'
end

target 'NazaboreTests' do
	pod 'Kiwi'
	xcodeproj 'Nazabore.xcodeproj'
end

