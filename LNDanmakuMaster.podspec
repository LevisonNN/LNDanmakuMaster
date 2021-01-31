Pod::Spec.new do |s|
  s.name         = "LNDanmakuMaster"
  s.version      = "0.0.1"
  s.summary      = "A feature-rich danmaku component."
  s.homepage     = "https://github.com/LevisonNN/LNDanmakuMaster"
  s.author             = { "Levison" => "levisoncn@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/LevisonNN/LNDanmakuMaster.git", :tag => "#{s.version}" }
  #s.source_files  = "Classes", "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/**/*.{h,m}"
  s.source_files  = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster.h"
  s.license      = "MIT"
  s.requires_arc = true

  s.subspec 'UIElements' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/UIElements/**/*.{h,m}"
  end

  s.subspec 'Attributes' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/Attributes/**/*.{h,m}"
  end

  s.subspec 'Pool' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/Pool/**/*.{h,m}"
  end
  
  s.subspec 'ContainerView' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/ContainerView/**/*.{h,m}"
    ss.dependency "LNDanmakuMaster/Attributes"
    ss.dependency "LNDanmakuMaster/Track"
  end

  s.subspec 'Dispatcher' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/Dispatcher/**/*.{h,m}"
    ss.dependency "LNDanmakuMaster/Attributes"
    ss.dependency "LNDanmakuMaster/Track"
    ss.dependency "LNDanmakuMaster/Clock"
  end

  s.subspec 'Track' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/Track/**/*.{h,m}"
    ss.dependency "LNDanmakuMaster/Attributes"
  end

  s.subspec 'TrackGroup' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/TrackGroup/**/*.{h,m}"
    ss.dependency "LNDanmakuMaster/Attributes"
    ss.dependency "LNDanmakuMaster/Dispatcher"
    ss.dependency "LNDanmakuMaster/Track"
    ss.dependency "LNDanmakuMaster/Clock"
  end

  s.subspec 'Clock' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/Clock/**/*.{h,m}"
  end

  s.subspec 'Player' do |ss|
    ss.source_files = "LNDanmakuMaster/LNDanmakuMaster/LNDanmakuMaster/Player/**/*.{h,m}"
    ss.dependency "LNDanmakuMaster/Dispatcher"
    ss.dependency "LNDanmakuMaster/ContainerView"
    ss.dependency "LNDanmakuMaster/Track"
    ss.dependency "LNDanmakuMaster/TrackGroup"
    ss.dependency "LNDanmakuMaster/Clock"
    ss.dependency "LNDanmakuMaster/Pool"
    ss.dependency "LNDanmakuMaster/Attributes"
  end
end

