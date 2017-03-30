Pod::Spec.new do |s|


  s.name         = "CBRoundedCorners"
  s.version      = "1.0.2"
  s.summary      = "A extension for create rounded corners."
  s.description  = <<-DESC
                   It is a rounded corners used on iOS, which implement by Swift3.0
                   DESC

  s.homepage     = "https://github.com/bililioo/CBRoundedCorners"
  s.license      = "MIT"
  s.author             = { "chenbin" => "bunchan16@yahoo.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/bililioo/CBRoundedCorners.git", :tag => "#{s.version}" }

  s.source_files  = "CBRoundedCorners/*"

  s.framework  = "UIKit"
end
