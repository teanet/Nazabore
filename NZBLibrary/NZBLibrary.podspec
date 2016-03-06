Pod::Spec.new do |s|
  s.name            = "NZBLibrary"
  s.version         = "0.0.1"
  s.summary         = "Example of creating own pod."
  s.homepage        = "https://github.com/username/MyCustomPod"
  s.license         = { :type => 'MIT', :file => 'LICENSE' }
  s.author          = { "Username" => "username@mail.domain" }
  s.platform        = :ios, 8.0
  s.source          = { :git => "https://github.com/username/MyCustomPod.git", :tag => s.version.to_s }
  s.framework       = 'Foundation'
  s.requires_arc    = true
  s.default_subspec = 'Core' # Модуль по умолчанию называется Core

  s.subspec 'Core' do |core|
    #core.source_files        = 'Classes/AKClass.{h,m}'
    s.public_header_files   = 'CoreClasses/*.h'
    core.dependency 'NZBLibrary/Network'
  end

  s.subspec 'Network' do |network|
    network.source_files = 'NetworkClasses/*.{h,m}'
    network.dependency 'ReactiveCocoa', '~> 2.5'
    network.dependency 'AFNetworking', '~> 2.5'
    network.dependency 'NZBLibrary/Entities'
  end

  s.subspec 'Entities' do |entities|
    entities.source_files = 'EntitiesClasses/*.{h,m}'
    entities.frameworks   = 'Foundation', 'CoreLocation'
  end

end