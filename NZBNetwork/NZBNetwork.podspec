Pod::Spec.new do |s|

  s.name         = "NZBNetwork"
  s.version      = "0.0.1"
  s.summary      = "Nazabore network module"

  s.homepage     = "http://EXAMPLE/NZBNetwork"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT (example)"
  s.author             = { "e.tyutyuev" => "e.tyutyuev@2gis.ru" }
  # Or just: s.author    = "e.tyutyuev"
  # s.authors            = { "e.tyutyuev" => "e.tyutyuev@2gis.ru" }
  # s.social_media_url   = "http://twitter.com/e.tyutyuev"

  s.platform               = :ios
  s.ios.deployment_target  = "8.0"
  # s.watchos.deployment_target = "2.0"

  # s.source       = { :git => "http://EXAMPLE/NZBEntities.git", :tag => "0.0.1" }

  s.source_files  = "NZBNetwork", "NZBNetwork/**/*.{h,m}"
  s.exclude_files = "NZBNetwork/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.framework  = "Foundation"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency 'NZBEntities', :podspec => 'https://raw.github.com/yaakov-h/SKSteamKit/master/podspecs/ProtocolBuffers.podspec'
  s.dependency 'ReactiveCocoa', '~> 2.5'
  s.dependency 'AFNetworking', '~> 2.5'
end
