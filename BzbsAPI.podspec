#
#  Be sure to run `pod spec lint iOS_BzbsAPI.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "BzbsAPI"
  spec.version      = "0.0.1"
  spec.summary      = "A BzbsAPI system for access to Buzzebee royalty"
  spec.description  = <<-DESC
  A system API to works with our Buzzebees system.
                   DESC

  spec.homepage     = 'https://github.com/saowalak@gmail.com'

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author       = { "Saowalak Rungrat" => "saowalak.r@buzzebees.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"

  spec.source       = { :git => "https://github.com/Poppy0729/BzbsAPI.git", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  
  spec.source_files  = "iOS_BzbsAPI/Classes/**/*.{swift,h,m}"
  spec.resource = "iOS_BzbsAPI/Classes/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"
# spec.exclude_files = "Classes/Exclude"

  # spec.public_header_files = "Classes/**/*.h"
  

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.ios.deployment_target = '13.0'
  spec.swift_version = '5.3'
  
  spec.dependency "Alamofire"

end
