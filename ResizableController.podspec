#
#  Be sure to run `pod spec lint ResizableController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ResizableController"
  spec.version      = "0.0.1"
  spec.summary      = "ResizableController for Custom Model Presentation"
  spec.description  = <<-DESC
  A Custom Presentation which acts as a custom-sizing view as well as full presented view. While doing this presentation, it manages to render background view which gives the view hierarchy, a nice 3D effect. Check screenshot for more details.
                   DESC

  spec.source_files = "ResizableController/**/*.{swift,h}"
  spec.homepage = "https://rupee.paytmmoney.com/ios/ResizableController"
  spec.source = { :git => "git@github.com:paytmmoney/ResizableController.git",
:branch => 'dev/0.1' }

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "Arjun Baru" => "arjun.baru@paytmmoney.com" }
  spec.social_media_url   = "https://linkedin.com/in/arjun-baru-800785111"

  spec.platform = :ios, "11.0"
  spec.swift_version = "5"
end
