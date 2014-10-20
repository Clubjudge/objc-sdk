Pod::Spec.new do |s|

  s.name                 = "CJKit"
  s.version              = "3.2.5"
  s.summary              = "An Objective-C wrapper for the ClubJudge API"
  s.homepage             = "https://github.com/clubjudge/objc-sdk"

  s.license              = { :type => "MIT", :file => "LICENSE" }
  s.author               = { "Bruno Abrantes" => "bruno.abrantes@clubjudge.com" }
  s.platform             = :ios, "6.0"
  s.source               = { :git => "https://github.com/clubjudge/objc-sdk.git", :tag => s.version.to_s }

  s.default_subspec      = "base"

  s.subspec "base" do |ss|
    ss.source_files = "Classes/CJkit.h", "Classes/Engine/*.{h,m}", "Classes/Models/*.{h,m}", "Classes/Engine/*.{h,m}", "Classes/Models/*.{h,m}", "Classes/Request/*.{h,m}", "Classes/Categories/CJModel+{Following,Distance,Images}.{h,m}", "Classes/Categories/NSDate+StringParsing.{h,m}", "Classes/Serializers/*.{h,m}", "Classes/Controllers/CJPersistentQueueController.{h,m}"
  end

  s.subspec "PromiseKit" do |ss|
    ss.dependency "PromiseKit/base", "~> 0.9.8.1"
    ss.dependency 'CJKit/base', "~> #{s.version.to_s}"
    ss.source_files = "Classes/Categories/CJKit+PromiseKit.{h,m}", "Classes/Categories/CJAPIRequest+PromiseKit.{h,m}", "Classes/Categories/CJEngine+PromiseKit.{h,m}"
  end

  s.subspec "BAPersistentOperationQueue" do |ss|
    ss.dependency 'CJKit/base', "~> #{s.version.to_s}"
    ss.source_files = "Classes/Categories/CJEngine+CJPersistentQueueController.{h,m}"
  end

  s.public_header_files  = "Classes/**/*.h"

  s.framework            = "CoreLocation"

  s.requires_arc         = true

  s.dependency           "AFNetworking", "~> 2.4"
  s.dependency           "ObjectiveSugar"
  s.dependency           "BAPersistentOperationQueue"

end
