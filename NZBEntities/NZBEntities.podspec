Pod::Spec.new do |s|

  s.name         = "NZBEntities"
  s.version      = "0.0.1"
  s.summary      = "All nazabore entities"

  s.homepage     = "http://EXAMPLE/NZBEntities"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT (example)"
  s.author             = { "e.tyutyuev" => "e.tyutyuev@2gis.ru" }
  # Or just: s.author    = "e.tyutyuev"
  # s.authors            = { "e.tyutyuev" => "e.tyutyuev@2gis.ru" }
  # s.social_media_url   = "http://twitter.com/e.tyutyuev"

  s.platform               = :ios
  s.ios.deployment_target  = "8.0"
  s.watchos.deployment_target = "2.0"

  # s.source       = { :git => "http://EXAMPLE/NZBEntities.git", :tag => "0.0.1" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.framework  = "Foundation", "CoreLocation"
  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end
