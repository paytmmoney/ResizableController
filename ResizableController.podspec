#
#  Be sure to run `pod spec lint ResizableController.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name          = "ResizableController"
  spec.version       = "1.0.0"
  spec.summary       = "ResizableController for Custom Model Presentation"
  spec.description   = "A Custom Presentation which acts as a custom-sizing view as well as full presented view. While doing this presentation, it manages to render background view which gives the view hierarchy, a nice 3D effect. Check screenshot for more details."

  spec.source_files  = "ResizableController/**/*.{swift,h}"
  spec.homepage      = "https://github.com/paytmmoney/ResizableController"
  spec.source        = { :git => "https://github.com/paytmmoney/ResizableController.git",
:tag => '1.0.0' }

  spec.license       = { :type => "MIT", :file => "LICENSE" }

  spec.author        = { "Arjun Baru" => "arjun.baru@paytmmoney.com" }

  spec.platform      = :ios, "11.0"
  spec.swift_version = "5"
end
